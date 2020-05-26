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

variable "key" {
  default     = ""
  description = "The path to a private key file for envoy"
}

variable "cert" {
  default     = ""
  description = "The path to a signed cert file for envoy"
}

variable "envoy_tag" {
  default     = "v1.14.1"
  description = "The envoy docker tag to deploy"
}

variable "envoy_image" {
  default     = "envoyproxy/envoy"
  description = "The envoy docker image to deploy"
}

variable "envoy_tls" {
  default     = false
  description = "Flag to use a tls enabled envoy config"
}

variable "envoy_cert_auto_gen" {
  default     = true
  description = "Flag to generate a self signed key and cert. Set to false to pass your own key and cert"
}

variable "envoy_port" {
  default     = 50051
  description = "The host access port to listen on"
}

variable "envoy_privileged_port" {
  default     = 50052
  description = "The host access privileged port to listen on"
}

variable "enable_tdagent" {
  default     = true
  description = "A flag to install td-agent that forwards logs to the monitor host"
}

variable "custom_config_path" {
  default     = ""
  description = "Add a custom path to an envoy config directory"
}

variable "internal_domain" {
  default     = "internal.scalar-labs.com"
  description = "The internal domain"
}
