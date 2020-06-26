variable "bastion_host_ip" {
  description = "The Public IP address to the Bastion Host"
}

variable "private_key_path" {
  description = "The path to a private key (.pem) file for auth"
}

variable "user_name" {
  description = "The user of the remote instance to provision"
}

variable "use_agent" {
  description = "Use ssh-agent for authentication when logging in through the bastion node."
  default     = "true"
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
  description = "A list of C* hosts (IP or DNS) to provision"
}

variable "provision_count" {
  description = "The number of bastion resources to provision"
}

variable "enable_tdagent" {
  default     = true
  description = "A flag to install td-agent that forwards logs to the monitor host"
}

variable "internal_domain" {
  default     = "internal.scalar-labs.com"
  description = "The internal domain"
}

variable "pulsar_component" {
  description = "The component type of Pulsar"
}

variable "broker_server" {
  default     = "127.0.0.1"
  description = "The private ip of Broker cluster to Initialize cluster metadata"
}
