# Envoy Cluster
The Envoy cluster module deploys a front facing service that accepts grpc_web, terminate TLS, and routes traffic based on HTTP2/HTTP1.1 protocols.

## Overview
This module will provision a host with a Docker Engine, that will run an Envoy server. The Envoy server can be deployed in two modes, secured and unsecured, using `envoy_tls` flag. If secured mode is used, by default a self-signed cert and private key will be generated, however you can specified a key and cert by setting the `envoy_cert_auto_gen` to false and providing paths to a private `key` and `cert`.  

### Variable

#### Required
* bastion_host_ip - (required)
* private_key_path - (required)
* user_name - (required)
* host_list - (required)
* provision_count - (required)

#### Optional
* triggers (list) - A list of triggers to initiate provisioning

* key (string) - A private key file path for Envoy TLS
* cert (string) - A cert file path for Envoy TLS
* envoy_tls (boolean) - Flag to enable TLS connection
* envoy_cert_auto_gen (boolean) - Flag to generate self-signed cert (Set to False to use user provided cert)

* envoy_port (number) - The port number to listen for incoming traffic
* envoy_image (string) - The docker image for envoy
* envoy_tag (string) - The docker tag for envoy

### Example Config

Basic unsecured mode
```
envoy_tls = false
envoy_port = 50051
envoy_image = envoyproxy/envoy
envoy_tag = v1.10.0
```

Secure Mode (self-signed)
```
envoy_tls = true
envoy_cert_auto_gen = true
envoy_port = 50051
envoy_image = envoyproxy/envoy
envoy_tag = v1.10.0
```

Secure Mode (user provided key and cert)
```
envoy_tls = true
envoy_cert_auto_gen = false
key = ~/path/to/key.pem
cert = ~/path/to/cert.pem
envoy_port = 50051
envoy_image = envoyproxy/envoy
envoy_tag = v1.10.0
```
