# ----root/variables.tf------

variable "aws_region" {}
variable "aws_profile" {}
variable "project_name" {}

#---networking variables----
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


#-------storage--------
variable "domain_name" {}

#------DB------
variable "db_instance_class" {}
variable "dbname" {}
variable "dbuser" {}
variable "dbpassword" {}

#---ansible---
variable "public_key_path" {}

#-----compute----
variable "dev_instance_type" {}
variable "dev_ami" {}


