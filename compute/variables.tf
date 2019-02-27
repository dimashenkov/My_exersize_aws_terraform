#----------compute/vars.tf--------
variable "db_instance_class" {}
variable "dbname" {}
variable "dbuser" {}
variable "dbpassword" {}

variable "dev_instance_type" {}
variable "dev_ami" {}

variable "domain_name" {}
#--from network---
variable "public_subnets" {
	type = "list"
}
variable "public_sg" {}
variable "subnet_ips" {
	type = "list"
}
variable "db_subnet_group_name" {}
variable "vpc_security_group_ids" {}

variable "wp_dev_public_ip" {}

#---------
variable "public_key_path" {}

#---from IAM---
variable "iam_instance_profile" {}

#-----from storage--------
variable "s3code" {}
