# Cassandra AWS Module
The Cassandra AWS module deploys a Cassandra cluster tuned for a Scalar DL environment.

#### Internal URL:
`cassandra-[1-3].internal.scalar-labs.com`

#### Required
| name | type | comment
| --------- | --------- | ----------
| network_name | string | Short name to identify environment.
| bastion_ip | string | Public IP address to bastion host.
| network_cidr | string | Network CIDR address space. (default: 10.42.0.0/16)
| network_id | string | The VPC network ID.
| network_dns | string | The VPC network DNS ID.
| private_key_path | string | File path to private key for ssh access.
| user_name | string | The username to connect to backend hosts.
| image_id | string | The AMI ID that will be launched.
| key_name | string | The AWS managed private/public key name.

#### Optional
| name | type | comment
| --------- | --------- | ----------
| triggers | Array<string> | Triggers will indicate when to start provisioning steps.
| resource_type | string | The type of instance to create. (default: t3.large)
| resource_root_volume_size | string | The size in GB of the root volume.
| enable_data_volume | boolean | A flag to attach a data volume for cassandra.
| enable_nlb | boolean | A flag to enable a network load balancer.
| data_remote_volume_size | string | The size in GB of the data volume for cassandra.
| data_use_local_volume | boolean | A flag to use resource temporary NVME attached storage.
| enable_commitlog_volume | boolean | A flag to attach a commitlog volume for cassandra.
| commitlog_remote_volume_size | string | The size in GB of the commitlog volume for cassandra.
| commitlog_use_local_volume | boolean | A flag to use resource temporary NVME attached storage.
| enable_tdagent | boolean | A flag to enable TD log collection agent. (default: true)
| start_on_initial_boot | boolean | A flag to start Cassandra or not on the initial boot. (default: false)

### Output
| name | type | comment
| --------- | --------- | ----------
| cassandra_provision_id | string | The ID of the provisioning step.
| cassandra_host_ips | List<string> | A list of host IP addresess for the cassandra cluster.
| cassandra_seed_ips | List<string> | A list of host IP addresess for the cassandra seeds.
| cassandra_host_ids | List<string> | A list of host ids for the cassandra cluster.
| cassandra_security_id | string | The security group ID of the cassandra cluster.
| cassandra_hosts | List<string> | A list of dns urls to access the cassandra cluster.
| cassandra_nlb_enabled | boolean | A flag to enable a network load balancer.
