# General Settings
variable "region" {
  defualt = "ap-northeast-1"
}

variable "base" {
  default = "default"
}

variable "cassandra" {
  type    = map
  default = {}
}

variable "cassy" {
  type    = map
  default = {}
}

variable "reaper" {
  type    = map
  default = {}
}
