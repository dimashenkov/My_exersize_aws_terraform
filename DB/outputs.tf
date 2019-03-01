#----------------db/outputs.tf---------------
output "wp_db_address" {
  value = "${aws_db_instance.wp_db.address}"
}
