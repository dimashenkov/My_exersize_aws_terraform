#---networking/main.tf------
# Declare the data source
data "aws_availability_zones" "available" {}

resource "aws_vpc" "wp_vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags {
    Name = "wp_vpc"
  }
}

#internet gateway
resource "aws_internet_gateway" "wp_internet_gateway" {
  vpc_id = "${aws_vpc.wp_vpc.id}"

  tags {
    Name = "wp_igw"
  }
}

# Route tables

resource "aws_route_table" "wp_public_rt" {
  vpc_id = "${aws_vpc.wp_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.wp_internet_gateway.id}"
  }

  tags {
    Name = "wp_public"
  }
}

resource "aws_default_route_table" "wp_private_rt" {
  default_route_table_id = "${aws_vpc.wp_vpc.default_route_table_id}"

  tags {
    Name = "wp_private"
  }
}

#2 public subnets

resource "aws_subnet" "wp_public_subnet" {
  count                   = 2
  vpc_id                  = "${aws_vpc.wp_vpc.id}"
  cidr_block              = "${var.public_cidrs[count.index]}"
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"

  tags = {
    Name = "wp_public_${count.index+1}"
  }
}

# 2 private subnets

resource "aws_subnet" "wp_private_subnet" {
  count                   = 2
  vpc_id                  = "${aws_vpc.wp_vpc.id}"
  cidr_block              = "${var.private_cidrs[count.index]}"
  map_public_ip_on_launch = false
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"

  tags = {
    Name = "wp_private_${count.index+1}"
  }
}

# 3 RDS subnets

resource "aws_subnet" "wp_rds_subnet" {
  count                   = 3
  vpc_id                  = "${aws_vpc.wp_vpc.id}"
  cidr_block              = "${var.rds_cidrs[count.index]}"
  map_public_ip_on_launch = false
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"

  tags = {
    Name = "wp_rds_${count.index+1}"
  }
}

#S3 VPC endpoint
resource "aws_vpc_endpoint" "wp_private-s3_endpoint" {
  vpc_id       = "${aws_vpc.wp_vpc.id}"
  service_name = "com.amazonaws.${var.aws_region}.s3"

  route_table_ids = ["${aws_vpc.wp_vpc.main_route_table_id}",
    "${aws_route_table.wp_public_rt.id}",
  ]

  policy = <<POLICY
{
    "Statement": [
        {
            "Action": "*",
            "Effect": "Allow",
            "Resource": "*",
            "Principal": "*"
        }
    ]
}
POLICY
}

# PUBLIC Association/zaka4ane route tables to subnets
resource "aws_route_table_association" "wp_public_assoc" {
  count          = "${aws_subnet.wp_public_subnet.count}"
  subnet_id      = "${aws_subnet.wp_public_subnet.*.id[count.index]}"
  route_table_id = "${aws_route_table.wp_public_rt.id}"
}

# PRIVAT  Association/zaka4ane route tables to subnets
resource "aws_route_table_association" "wp_private_assoc" {
  count          = "${aws_subnet.wp_private_subnet.count}"
  subnet_id      = "${aws_subnet.wp_private_subnet.*.id[count.index]}"
  route_table_id = "${aws_default_route_table.wp_private_rt.id}"
}

#RDS association group with subnets
resource "aws_db_subnet_group" "wp_rds_subnetgroup" {
  name = "wp_rds_subnetgroup"

  subnet_ids = ["${aws_subnet.wp_rds_subnet.*.id}"]

  tags {
    Name = "wp_rds_sng"
  }
}

#SECURITY

#DEV security group
resource "aws_security_group" "wp_dev_sg" {
  name        = "wp_dev_sg"
  description = "Used for access to the dev instance"
  vpc_id      = "${aws_vpc.wp_vpc.id}"

  #SSH

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.accessip}"]
  }

  #HTTP

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"          #zna4i vsi4ki protokoli
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Public Security group

resource "aws_security_group" "wp_public_sg" {
  name        = "wp_public_sg"
  description = "Used for public and private instances for load balancer access"
  vpc_id      = "${aws_vpc.wp_vpc.id}"

  #HTTP 

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Outbound internet access

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Private Security Group

resource "aws_security_group" "wp_private_sg" {
  name        = "wp_private_sg"
  description = "Used for private instances"
  vpc_id      = "${aws_vpc.wp_vpc.id}"

  # Access from other security groups
  #Access  from VPC
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#RDS Security Group
resource "aws_security_group" "wp_rds_sg" {
  name        = "wp_rds_sg"
  description = "Used for DB instances"
  vpc_id      = "${aws_vpc.wp_vpc.id}"

  # SQL access from public/private/dev security group

  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
# moje i s sidr block  no za u4ebna cel napraveno s sec groups
    security_groups = ["${aws_security_group.wp_dev_sg.id}",
      "${aws_security_group.wp_public_sg.id}",
      "${aws_security_group.wp_private_sg.id}",
    ]
  }
}
