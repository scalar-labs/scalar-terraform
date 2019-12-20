#Required Variable
variable "name" {
  description = "A short name to attach to resources"
}

variable "location" {
  description = "The AWS availability zone to deploy environment `ap-northeast-1a`"
}

variable "user_name" {
  default     = "centos"
  description = "The username to use for backend resources."
}

variable "public_key_path" {
  description = "The path to a public key file ~/.ssh/key.pub"
}

variable "private_key_path" {
  description = "The path to a private key file ~/.ssh/key.pem"
}

variable "bastion_resource_type" {
  default     = "t3.micro"
  description = "The size for bastion resource. Example t3.micro"
}

#Optional Variables
variable "cidr" {
  default     = "10.42.0.0/16"
  description = "The address space to assign to the network"
}

variable "internal_root_dns" {
  default     = "internal.scalar-labs.com"
  description = "An internal DNS domain name to use for mapping IP addresses"
}
