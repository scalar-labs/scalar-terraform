#!/bin/bash

cqlsh -u "${SCALAR_DB_USERNAME}" \
      -p "${SCALAR_DB_PASSWORD}" \
      -f ./create_schema.cql \
      "${SCALAR_DB_CONTACT_POINTS}" "${SCALAR_DB_CONTACT_PORT}"
