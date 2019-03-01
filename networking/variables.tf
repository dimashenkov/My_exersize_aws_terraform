#---networking/variables.tf------

variable "vpc_cidr" {}

variable "public_cidrs" {
  type = "list"
}

variable "private_cidrs" {
  type = "list"
}

variable "rds_cidrs" {
  type = "list"
}

variable "accessip" {
  type = "list"
}

variable "aws_region" {}

variable "domain_name" {}

variable "elb_healthy_threshold" {}
variable "elb_unhealthy_threshold" {}
variable "elb_timeout" {}
variable "elb_interval" {}


