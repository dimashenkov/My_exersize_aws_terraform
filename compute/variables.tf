#----------compute/vars.tf--------
variable "db_instance_class" {}
variable "dbname" {}
variable "dbuser" {}
variable "dbpassword" {}

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