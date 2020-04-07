variable "network_name" {
  description = "The name of the network resources: should be generated by provider/universal/name-generator"
}

variable "network_id" {
  description = "The id of the cloud provider network ID resource"
}

variable "network_cidr" {
  description = "The network cidr address space"
}

variable "network_dns" {
  description = "The ID for the internal DNS zone"
}

variable "location" {
  description = "The Azure location to deploy environment"
}

variable "public_key_path" {
  description = "The path to the public key for SSH access"
}

variable "private_key_path" {
  description = "The path to the private key for SSH access"
}

variable "additional_public_keys_path" {
  description = "The path to the multiple public key folder for SSH access."
}

variable "user_name" {
  description = "The user name of the remote hosts"
}

variable "subnet_id" {
  description = "The subnet ID to launch bastion host. Should be a public subnet"
}

variable "trigger" {
  default     = ""
  description = "A trigger key that will initiate provisioning of bastion resource"
}

variable "resource_type" {
  description = "The resource type of the bastion instance"
}

variable "resource_root_volume_size" {}

variable "bastion_access_cidr" {
  description = "You can limit access to the bastion node to a specified IP cidr range"
}

variable "image_id" {
  description = "The image id to initiate"
}

variable "enable_tdagent" {
  description = "A flag to install td-agent that forwards logs to the monitor host"
}
