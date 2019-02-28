#----------compute/vars.tf--------
variable "db_instance_class" {}
variable "dbname" {}
variable "dbuser" {}
variable "dbpassword" {}

variable "dev_instance_type" {}
variable "dev_ami" {}
variable "key_name" {}

variable "domain_name" {}

#--from network---
variable "public_subnets" {
	type = "list"
}

variable "private_subnets" {
	type = "list"
}
variable "public_sg" {}
variable "private_sg" {}
variable "subnet_ips" {
	type = "list"
}
variable "db_subnet_group_name" {}
variable "wp_rds_security_group_ids" {}
variable "wp_dev_security_group_ids" {}
variable "wp_elb_id" {}

#---------
variable "public_key_path" {}

#---from IAM---
variable "iam_instance_profile" {}

#-----from storage--------
variable "s3code" {}

#----golden AMI----
variable "lc_instance_type" {}

#---for Auto scaling----
variable "asg_max" {}
variable "asg_min" {}
variable "asg_grace" {}
variable "asg_hct" {}
variable "asg_cap" {}