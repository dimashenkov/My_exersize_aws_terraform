#-----root/main.tf----
provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.aws_profile}"
}

# Create IMA for s3

module "ima" {
  source = "./ima"
}

# Deploy networking resource

module "networking" {
  source        = "./networking"
  vpc_cidr      = "${var.vpc_cidr}"
  public_cidrs  = "${var.public_cidrs}"
  private_cidrs = "${var.private_cidrs}"
  rds_cidrs     = "${var.rds_cidrs}"
  aws_region    = "${var.aws_region}"
  accessip      = "${var.accessip}"
}

# Deploy storage s3

module "storage" {
  source = "./storage"
  domain_name = "${var.domain_name}"
}

# Deploy Compute Resource
module "compute" {
  source          = "./compute"

  public_subnets  = "${module.networking.public_subnets}"
  public_sg       = "${module.networking.public_sg}"
  subnet_ips      = "${module.networking.subnet_ips}"
  
  db_subnet_group_name = "${module.networking.db_subnet_group_name}"
  vpc_security_group_ids = "${module.networking.vpc_security_group_ids}"
}