variable "project_id" {}
variable "region" {}
variable "zone" {}
variable "user_email" {}

variable "network_name" {
  default = "custom-vpc"
}

variable "subnet_cidr" {
  default = "10.0.0.0/24"
}

variable "instance_name" {
  default = "wordpress-vm"
}