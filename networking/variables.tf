#---networking/variables.tf------

variable "vpc_cidr" {}
variable "public_cidrs" {
  type = "list"
}
variable "privat_cidrs" {
  type = "list"
}
