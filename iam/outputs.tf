#-----IAM/outputs.tf--------------
output "iam_instance_profile" {
  value = "${aws_iam_instance_profile.s3_access_profile.id}"
}