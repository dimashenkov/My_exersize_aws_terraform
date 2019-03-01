#-----root/main.tf----
provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.aws_profile}"
}

# Create IAM for s3

module "iam" {
  source = "./iam"
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
  elb_healthy_threshold   = "${var.elb_healthy_threshold}"
  elb_unhealthy_threshold = "${var.elb_unhealthy_threshold}"
  elb_timeout     = "${var.elb_timeout}"
  elb_interval    = "${var.elb_interval}"

}

# Deploy storage s3

module "storage" {
  source = "./storage"
  domain_name = "${var.domain_name}"
}

# Deploy Compute Resource
module "compute" {
  source          = "./compute"
  db_instance_class = "${var.db_instance_class}"
  dbname = "${var.dbname}"
  dbuser = "${var.dbuser}"
  dbpassword = "${var.dbpassword}"
  domain_name = "${var.domain_name}"


  public_key_path ="${var.public_key_path}"
  key_name = "${var.key_name}"

  public_subnets  = "${module.networking.public_subnets}"
  private_subnets  = "${module.networking.private_subnets}"
  public_sg       = "${module.networking.public_sg}"
  private_sg      = "${module.networking.private_sg}"
  subnet_ips      = "${module.networking.subnet_ips}"

  
  
  db_subnet_group_name = "${module.networking.db_subnet_group_name}"
  wp_rds_security_group_ids = "${module.networking.wp_rds_security_group_ids}"
  wp_dev_security_group_ids = "${module.networking.wp_dev_security_group_ids}"
  wp_elb_id = "${module.networking.wp_elb_id}"

  iam_instance_profile = "${module.iam.iam_instance_profile}"
  s3code = "${module.storage.s3code}"
  lc_instance_type = "${var.lc_instance_type}"
  dev_instance_type = "${var.dev_instance_type}"
  dev_ami     = "${var.dev_ami}"

  asg_max = "${var.asg_max}"
  asg_min = "${var.asg_min}"
  asg_grace = "${var.asg_grace}"
  asg_hct = "${var.asg_hct}"
  asg_cap = "${var.asg_cap}"

}

#Deploy route53
module "route53" {
  source          = "./route53"
  domain_name     = "${var.domain_name}"
  delegation_set = "${var.delegation_set}"
  wp_dev_public_ip = "${module.compute.wp_dev_public_ip}"
  wp_db_address = "${module.compute.wp_db_address}"
  wp_elb_dns_name = "${module.networking.wp_elb_dns_name}"
  wp_elb_zone_id = "${module.networking.wp_elb_zone_id}"
  wp_vpc_id = "${module.networking.wp_vpc_id}"
    
}