#------storage/outputs.tf
output "s3code" {
  value = "${aws_s3_bucket.code.bucket}"
}

output "bucketname" {
  value = "${aws_s3_bucket.code.id}"
}