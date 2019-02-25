provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.aws_profile}"
}


# Create IMA for s3

module "ima" {
  source       = "./ima"
  project_name = "${var.project_name}"
}

