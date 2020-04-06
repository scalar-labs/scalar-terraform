#!/bin/bash

cqlsh -u "${SCALAR_CASSANDRA_USER}" \
      -p "${SCALAR_CASSANDRA_PASSWORD}" \
      -f ./create_schema.cql \
      "${SCALAR_CASSANDRA_HOST}" "${SCALAR_CASSANDRA_PORT}"
