# Bastion Azure Module
The bastion module deploys a network bastion host used to access and configure the environment.

#### Required
| name | type | comment
| --------- | --------- | ----------
| network_name | string | Short name to identify environment.
| bastion_ip | string | Public IP address to bastion host.
| network_cidr | string | Network CIDR address space. (default: 10.42.0.0/16)
| network_id | string | The VPC network ID.
| network_dns | string | The VPC network DNS ID.
| private_key_path | string | File path to private key for ssh access.
| public_key_path | string | File path to public key for ssh access.
| user_name | string | The username to connect to backend hosts.
| image_id | string | The image ID that will be launched.

#### Optional
| name | type | comment
| --------- | --------- | ----------
| triggers | Array<string> | Triggers will indicate when to start provisioning steps.
| resource_type | string | The type of instance to create. (default: Standard_D2s_v3)
| resource_root_volume_size | string | The size in GB of the root volume.
| enable_tdagent | boolean | A flag to enable TD log collection agent. (default: true)
| bastion_access_cidr | string | The CIDR adddress space for allowed input connections. (default: 0.0.0.0/0)

### Output
| name | type | comment
| --------- | --------- | ----------
| bastion_host_ids | List<string> | A list of bastion hosts IDs.
| bastion_host_ips | List<string> | A list of bastion hosts IP addresses.
| bastion_security_group_id | string | The security group ID of the bastion resource.
| bastion_provision_id | string | The provisioning ID step.
