#-----------compute/outputs.tf----------
output "wp_dev_public_ip" {
	value = "${aws_instance.wp_dev.public_ip}"
}





