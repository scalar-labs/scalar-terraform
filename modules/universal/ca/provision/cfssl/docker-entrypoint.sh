#!/usr/bin/env bash
set -xEeo pipefail

if [[ ! ( -f $DATADIR/ca-server.pem && -f $DATADIR/ca-server-key.pem && \
          -f $DATADIR/server-ocsp.pem && -f $DATADIR/server-ocsp-key.pem ) ]]; then
  # Create a root CA certificate
  cfssl gencert -initca ca.csr.json | cfssljson -bare $DATADIR/ca
  # => ca.pem, ca.csr and ca-key.pem

  # Create an intermediate CA certificate
  cfssl gencert -ca $DATADIR/ca.pem -ca-key $DATADIR/ca-key.pem \
        -config cfssl-config.json -profile intermediate \
        server-ca.csr.json | cfssljson -bare $DATADIR/ca-server
  # => ca-server.pem, ca-server.csr and ca-server-key.pem

  # Create an OCSP server certificate
  cfssl gencert -ca $DATADIR/ca-server.pem -ca-key $DATADIR/ca-server-key.pem \
        -config cfssl-config.json -profile ocsp \
        ocsp.csr.json | cfssljson -bare $DATADIR/server-ocsp
  # => server-ocsp.pem, server-ocsp.csr and server-ocsp-key.pem

  # Create a CA bundle
  cat $DATADIR/ca.pem $DATADIR/ca-server.pem > $DATADIR/bundle.pem
fi

if [[ ! -f $DATADIR/certstore_development.db ]]; then
  # Run sqlite3 migration
  # This creates $DATADIR/certstore_development.db
  (cd $DATADIR; goose -path /workdir/certdb/sqlite up)
fi

case "$1" in
  serve)
    exec cfssl serve -address 0.0.0.0 -port 8888 \
         -config cfssl-config.json -db-config db-config.json \
         -ca-key $DATADIR/ca-server-key.pem -ca $DATADIR/ca-server.pem \
         -responder $DATADIR/server-ocsp.pem -responder-key $DATADIR/server-ocsp-key.pem
    ;;

  ocspserve)
    cfssl ocsprefresh -db-config db-config.json \
          -responder $DATADIR/server-ocsp.pem -responder-key $DATADIR/server-ocsp-key.pem \
          -ca $DATADIR/ca-server.pem
    cfssl ocspdump -db-config db-config.json > $DATADIR/ocspdump.txt
    exec cfssl ocspserve -address 0.0.0.0 -port 8889 -responses $DATADIR/ocspdump.txt
    ;;

  *)
    exec "$@"
    ;;
esac
