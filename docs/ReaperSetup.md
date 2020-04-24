# A Guide on How to Set up Reaper

This guide explains how to set up Reaper.
It assumes that you have already created Reaper instance with `scalar-terraform` properly and you have `ssh.cfg` at hand. Regarding how Reaper work, please take a look at [Reaper site](http://cassandra-reaper.io/).

## Configure Reaper to work with your Cassandra cluster

1. Port-forward Reaper port to access Reaper web UI from your local
    ```
    $ ssh -F ssh.cfg -L 8080:localhost:8080 reaper-1.internal.scalar-labs.com
    ```
    * Alternatively, you can add the following line under `Host bastion` section of `ssh.cfg`, and do `ssh -F ssh.cfg bastion`.
    ```
    LocalForward 8080 reaper-1.internal.scalar-labs.com:8080
    ```

1. Access Reaper web UI from your browser
    ```
    http://localhost:8080/webui
    ```
    Use admin/admin to login

1. Register your Cassandra cluster into Reaper

    1. Go to `Clusters`
    1. Set `cassandra-1.internal.scalar-labs.com` in Seed node box
    1. Press `Add Cluster`

    Note that this operation needs to be done only one time.

## Run a repair operation with Reaper

1. Repair `scalar` keyspace
    1. Go to `Repairs`
    1. Press `Start a new repair`
    1. Put `scalar` in Keyspace
    1. Press `Repair`
    1. Activate the repair

1. Repair `coordinator` keyspace
    1. Do the same process for `coordinator` keyspace
