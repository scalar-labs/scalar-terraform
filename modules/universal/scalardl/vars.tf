variable "bastion_host_ip" {
  description = "The Public IP address to the Bastion Host"
}

variable "private_key_path" {
  description = "The path to a private key (.pem) file for auth"
}

variable "user_name" {
  description = "The user of the remote instance to provision"
}

variable "triggers" {
  description = "A trigger to initiate provisioning"
  default     = []
}

variable "vm_ids" {
  default     = []
  description = "A list of virtual machine IDs to provision"
}

variable "host_list" {
  default     = []
  description = "A list of ScalarDL hosts (IP or DNS) to provision"
}

variable "provision_count" {
  description = "The number of resources to provision"
}

variable "scalardl_image_name" {
  description = "The docker image for Scalar DL"
}

variable "scalardl_image_tag" {
  description = "The docker image tag for Scalar DL"
}

variable "schema_loader_image" {
  default     = "scalarlabs/scalardl-schema-loader:1.1.0"
  description = "The docker image for the schema loader"
}

variable "enable_tdagent" {
  default     = true
  description = "A flag to install td-agent that forwards logs to the monitor host"
}

variable "internal_domain" {
  description = "Internal domain"
}

variable "database" {
  default     = "cassandra"
  description = "The database. This should be \"cassandra\" or \"dynamo\""
}

variable "database_contact_points" {
  description = "The database contact points"
}

variable "database_contact_port" {
  default     = 9042
  description = "The database contact port"
}

variable "database_username" {
  description = "The database username"
}

variable "database_password" {
  description = "The database password"
}

variable "cassandra_replication_factor" {
  default     = 3
  description = "The replication factor for the Cassandra schema"
}
