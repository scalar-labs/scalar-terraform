ARG FROM_SCALAR_IMAGE=scalarlabs/scalar-ledger:2.0.3
FROM ${FROM_SCALAR_IMAGE}

#Install cqlsh tool
RUN apt-get update && apt-get install -y curl gnupg apt-transport-https \
    && echo "deb https://downloads.apache.org/cassandra/debian 311x main" > /etc/apt/sources.list.d/cassandra.sources.list \
    && curl -fsSL https://downloads.apache.org/cassandra/KEYS | apt-key add - \
    && apt-get update && apt-get install -y cassandra-tools \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

#Copy templates from build step
COPY ./startup.sh ./
COPY ./create_schema.sh ./

RUN chmod 755 ./startup.sh
RUN chmod 755 ./create_schema.sh

ENV SCALAR_CASSANDRA_HOST ${SCALAR_CASSANDRA_HOST}
ENV SCALAR_CASSANDRA_PORT 9042
ENV SCALAR_CASSANDRA_USERNAME ${SCALAR_CASSANDRA_USERNAME}
ENV SCALAR_CASSANDRA_PASSWORD ${SCALAR_CASSANDRA_PASSWORD}
ENV CASSANDRA_REPLICATION_FACTOR ${CASSANDRA_REPLICATION_FACTOR}

CMD ["sh", "-c", "dockerize  -template ledger.properties.tmpl:ledger.properties -wait tcp://${SCALAR_CASSANDRA_HOST}:${SCALAR_CASSANDRA_PORT} -timeout 30s ./startup.sh"]

EXPOSE 50051 50052 50053
