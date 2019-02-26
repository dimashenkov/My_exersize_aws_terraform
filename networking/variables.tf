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
