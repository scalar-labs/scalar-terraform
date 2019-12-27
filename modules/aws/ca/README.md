# CA AWS Module
The CA module deploys a CA resource used to sign keys for Scalar DL.

#### Internal URL:
`ca.internal.scalar-labs.com`

#### Required
| name | type | comment
| --------- | --------- | ----------
| network_name | string | Short name to identify environment.
| bastion_ip | string | Public IP address to bastion host.
| network_cidr | string | Network CIDR address space. (default: 10.42.0.0/16)
| network_id | string | The VPC network ID.
| network_dns | string | The VPC network DNS id.
| private_key_path | string | File path to private key for ssh access.
| user_name | string | The username to connect to backend hosts.
| image_id | string | The AMI id that will be launched.
| key_name | string | The AWS managed private/public key name.


#### Optional
| name | type | comment
| --------- | --------- | ----------
| triggers | Array<string> | Triggers will indicate when to start provisioning steps.
| resource_type | string | The type of instance to create. (default: t2.micro)
| resource_root_volume_size | string | The size in GB of the root volume.
| enable_tdagent | boolean | A flag to enable TD log collection agent. (default: true)

### Output
none
