# A Guide on How to Set up Cassy

This guide explains how to set up Cassy.
It assumes that you have already created Cassy instance with `scalar-terraform` properly and you have `ssh.cfg` at hand. Regarding how Cassy work, please take a look at [Cassy site](https://github.com/scalar-labs/cassy).

## Configure Cassandra nodes to make them able to interact with a Cloud Storage

Cassy master tells each Cassandra node to upload backup files to Cloud Storages such as AWS S3 and Azure Blob Storage, each Cassandra node needs to have required configurations, for example config and credentials in AWS, for `cassandra` user.

If you deployed an environment on AWS with `scalar-terraform`, an IAM instance profile that allows EC2 instances to interact with the specified S3 bucket is created and attached to all Cassandra nodes. So you don't have to configure credentiails manually on each Cassandra node.

## Configure Cassy to work with your environment

1. Connect to a Cassy node
    ```
    $ ssh -F ssh.cfg cassy.internal.scalar-labs.com
    ```

1. Shutdown the docker container
    ```
    $ cd provision
    $ docker-compose down
    ```

1. Update the configuration
    ```
    $ vi conf/cassy.properties

    // the following variables need to be filled
    scalar.cassy.server.srv_service_url=
    ```

    e.g.
    ```
    scalar.cassy.server.srv_service_url=_scalardl._tcp.scalardl-service.internal.scalar-labs.com
    ```

1. Start the container and exit
    ```
    docker-compose up -d
    exit
    ```

## Interact with Cassy

1. Port-forward Cassy port to access Cassy from your local
    ```
    $ ssh -F ssh.cfg -L 20051:localhost:20051 cassy.internal.scalar-labs.com
    ```
    * Alternatively, you can add the following line under `Host bastion` section of `ssh.cfg`, and do `ssh -F ssh.cfg bastion`.
    ```
    LocalForward 20051 cassy.internal.scalar-labs.com:20051
    ```

1. Interact with Cassy
    ```
    $ grpcurl -plaintext -d '{"cassandra_host": "cassandra-1.internal.scalar-labs.com"}' localhost:20051 rpc.Cassy.RegisterCluster
    ```

    Please refer to [the doc](https://github.com/scalar-labs/cassy/blob/master/README.md) for the usage.
