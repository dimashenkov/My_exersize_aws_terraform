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
variable "elb_healthy_threshold" {}
variable "elb_unhealthy_threshold" {}
variable "elb_timeout" {}
variable "elb_interval" {}


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
variable "key_name" {}
variable "lc_instance_type" {}

variable "asg_max" {}
variable "asg_min" {}
variable "asg_grace" {}
variable "asg_hct" {}
variable "asg_cap" {}

