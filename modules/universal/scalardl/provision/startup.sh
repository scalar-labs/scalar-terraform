#!/bin/bash

version() {
  echo "$@"  | awk -F. '{ printf("%d%03d%03d\n", $1,$2,$3) }'
}

config_ops="-config ledger.properties"

if [[ $(version "${SCALAR_IMAGE_TAG}") -ge $(version "2.0.7") ]] ; then
  config_ops="-${config_ops}"
fi

./bin/scalar-ledger ${config_ops}
