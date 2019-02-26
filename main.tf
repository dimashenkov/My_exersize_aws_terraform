provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.aws_profile}"
}


# Create IMA for s3

module "ima" {
  source       = "./ima"
}

# Deploy networking resource

module "networking" {
  source       = "./networking"
  vpc_cidr     = "${var.vpc_cidr}"
  public_cidrs = "${var.public_cidrs}"
}

