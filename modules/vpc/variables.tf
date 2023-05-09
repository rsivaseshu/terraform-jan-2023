
variable "vpc_cidr_block" {
  type = string
  default = "192.168.0.0/16"
  description = "enter your cidr block range for vpc"
}

variable "env" {
  type = string
  description = "Enter your environment name"
}

variable "owner" {
  type = string
  description = "owner name"
}

variable "costcenter" {
  type = string
  description = "Enter your costceter id"
}

variable "enable_dns_hostnames" {
    type = string
    description = "enble dns hostnames defaults to false. if you want make it true"
    default=false
}
