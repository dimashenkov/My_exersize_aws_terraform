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