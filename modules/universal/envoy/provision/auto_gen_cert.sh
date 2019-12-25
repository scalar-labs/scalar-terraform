#!/bin/bash

if [ "${envoy_cert_auto_gen}" = "true" ]; then
  openssl req -x509 -nodes -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -subj '/CN=localhost';
fi
