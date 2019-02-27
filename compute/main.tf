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
  vpc_security_group_ids = ["${var.vpc_security_group_ids}"]
  skip_final_snapshot    = true             #bez taq opciq nemojesh da destroynesh
}

