#------------compute/main.tf----------------

#---------DB-----------

resource "aws_db_instance" "wp_db" {
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "5.7.23"
  instance_class         = "${var.db_instance_class}"
  name                   = "${var.dbname}"
  username               = "${var.dbuser}"
  password               = "${var.dbpassword}"

  db_subnet_group_name   = "${var.db_subnet_group_name}"
  vpc_security_group_ids = ["${var.wp_rds_security_group_ids}"]
  skip_final_snapshot    = true             #bez taq opciq nemojesh da destroynesh
}

#----- key pair and ansible provisioning---

resource "aws_key_pair" "wp_auth" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

#------dev server-----

resource "aws_instance" "wp_dev" {
  instance_type = "${var.dev_instance_type}"
  ami           = "${var.dev_ami}"           #amazon image for this instace

  tags {
    Name = "wp_dev"
  }

  key_name               = "${aws_key_pair.wp_auth.id}"
  vpc_security_group_ids = ["${var.wp_dev_security_group_ids}"]
  iam_instance_profile   = "${var.iam_instance_profile}"
  subnet_id              = "${element(var.public_subnets, 0)}"

  provisioner "local-exec" {
    command = <<EOD
cat <<EOF > aws_hosts 
[dev] 
${aws_instance.wp_dev.public_ip} 
[dev:vars] 
s3code=${var.s3code}
domain=${var.domain_name} 
EOF
EOD
  }
  provisioner "local-exec" {
    command = "aws ec2 wait instance-status-ok --instance-ids ${aws_instance.wp_dev.id} --profile superman && ansible-playbook -i aws_hosts wordpress.yml"
  }
}

#AMI Golden
#-----random ami ID------

resource "random_id" "golden_ami" {
  byte_length = 8
}

resource "aws_ami_from_instance" "wp_golden" {
  name               = "wp_ami-${random_id.golden_ami.b64}"
  source_instance_id = "${aws_instance.wp_dev.id}"

  provisioner "local-exec" {
    command = <<EOT
cat <<EOF > userdata
#!/bin/bash
/usr/bin/aws s3 sync s3://${var.s3code} /var/www/html/
/bin/touch /var/spool/cron/root
sudo /bin/echo '*/5 * * * * aws s3 sync s3://${var.s3code} /var/www/html/' >> /var/spool/cron/root
EOF
EOT
  }
}

#------launch configuration used for autoscaling groups--------

resource "aws_launch_configuration" "wp_lc" {
  name_prefix          = "wp_lc-"
  image_id             = "${aws_ami_from_instance.wp_golden.id}"
  instance_type        = "${var.lc_instance_type}"
  security_groups      = ["${var.private_sg}"]
  iam_instance_profile = "${var.iam_instance_profile}"
  key_name             = "${aws_key_pair.wp_auth.id}"
  user_data            = "${file("userdata")}"

  lifecycle {
    create_before_destroy = true #polezno pri blue green deploy
  }
}


#-----AutoScalingGroup--------- 

# resource "random_id" "rand_asg" {
# byte_length = 8
#}

resource "aws_autoscaling_group" "wp_asg" {
  name                      = "asg-${aws_launch_configuration.wp_lc.id}"
  max_size                  = "${var.asg_max}"
  min_size                  = "${var.asg_min}"
  health_check_grace_period = "${var.asg_grace}"
  health_check_type         = "${var.asg_hct}"
  desired_capacity          = "${var.asg_cap}"
  force_delete              = true
  load_balancers            = ["${var.wp_elb_id}"]

  #zonite v koito 6te deploiva -subneti 
  vpc_zone_identifier = ["${var.private_subnets}"]

  launch_configuration = "${aws_launch_configuration.wp_lc.name}"

  tag {
    key                 = "Name"
    value               = "wp_asg-instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}