# A Guide on How to Set up Cassy

This guide explains how to set up Cassy.
It assumes that you have already created Cassy instance with `scalar-terraform` properly and you have `ssh.cfg` at hand. Regarding how Cassy work, please take a look at [Cassy site](https://github.com/scalar-labs/cassy).

## Configure Cassandra nodes to make them able to interact with a Cloud Storage

Cassy master tells each Cassandra node to upload backup files to Cloud Storages such as AWS S3 and Azure Blob Storage, each Cassandra node needs to have required configurations, for example config and credentials in AWS, for `cassandra` user.

If you deploy to AWS with `scalar-terraform`, an IAM instance profile that allows EC2 instances to interact with the specified S3 bucket is created and attached to all Cassandra nodes. So you don't need to configure credentials manually on Cassandra nodes.

## Interact with Cassy

1. Port-forward Cassy port to access Cassy from your local
    ```
    $ ssh -F ssh.cfg -L 20051:localhost:20051 cassy-1.internal.scalar-labs.com
    ```
    * Alternatively, you can add the following line under `Host bastion` section of `ssh.cfg`, and do `ssh -F ssh.cfg bastion`.
    ```
    LocalForward 20051 cassy-1.internal.scalar-labs.com:20051
    ```

1. Interact with Cassy
    ```
    $ grpcurl -plaintext -d '{"cassandra_host": "cassandra-1.internal.scalar-labs.com"}' localhost:20051 rpc.Cassy.RegisterCluster
    ```

    Please refer to [the doc](https://github.com/scalar-labs/cassy/blob/master/README.md) for the usage.
