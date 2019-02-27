#storage/main.tf------

#S3 code bucket
## generate random ID
resource "random_id" "wp_code_bucket" {
  byte_length = 2
}
# create the bucket privat samo za infostrukturata nevidim otvun
resource "aws_s3_bucket" "code" {
  bucket        = "${var.domain_name}-${random_id.wp_code_bucket.dec}"
  acl           = "private"
  force_destroy = true

  tags {
    Name = "code bucket"
  }
}

