ARG FROM_SCALAR_TAG=1.3.1
ARG FROM_SCALAR_IMAGE=scalarlabs/scalar-ledger
FROM ${FROM_SCALAR_IMAGE}:${FROM_SCALAR_TAG}


#Install cqlsh tool
RUN apt-get update && apt-get install -y curl gnupg apt-transport-https \
&& curl -O -fsSL http://www.apache.org/dist/cassandra/KEYS && apt-key add KEYS
RUN echo "deb http://www.apache.org/dist/cassandra/debian 311x main" > /etc/apt/sources.list.d/cassandra.sources.list \
&& apt-get update && apt-get install -y cassandra-tools \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

#Copy templates from build step
COPY ./startup.sh ./
COPY ./create_schema.sh ./

RUN chmod 755 ./startup.sh
RUN chmod 755 ./create_schema.sh

ENV SCALAR_CASSANDRA_HOST 'cassandra-lb.internal.scalar-labs.com'
ENV SCALAR_CASSANDRA_PORT '9042'
ENV SCALAR_CASSANDRA_USERNAME ''
ENV SCALAR_CASSANDRA_PASSWORD ''
ENV CASSANDRA_REPLICATION_FACTOR '3'

CMD ["sh", "-c", "dockerize  -template ledger.properties.tmpl:ledger.properties -wait tcp://$SCALAR_CASSANDRA_HOST:$SCALAR_CASSANDRA_PORT -timeout 30s ./startup.sh"]

EXPOSE 50051 50052
