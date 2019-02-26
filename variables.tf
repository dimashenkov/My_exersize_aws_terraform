# ----root/variables.tf------

variable "aws_region" {}
variable "aws_profile" {}
variable "project_name" {}

#---networking variables----
variable "vpc_cidr" {}
variable "public_cidrs" {
  type = "list"
}
variable "privat_cidrs" {
  type = "list"
}
variable "rds_cidrs" {
  type = "list"
}

