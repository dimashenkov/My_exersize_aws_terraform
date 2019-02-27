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
