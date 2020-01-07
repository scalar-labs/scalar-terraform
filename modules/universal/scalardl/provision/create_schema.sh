#!/bin/bash

cqlsh $SCALAR_CASSANDRA_HOST $SCALAR_CASSANDRA_PORT -f ./create_schema.cql;
