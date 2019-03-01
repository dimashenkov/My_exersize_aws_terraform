#------Route53/main.tf-----
#---------Route53-------------

#primary zone

resource "aws_route53_zone" "primary" {
  name              = "${var.domain_name}.co.uk"
  delegation_set_id = "${var.delegation_set}"
}

#www 

resource "aws_route53_record" "www" {
  zone_id = "${aws_route53_zone.primary.zone_id}"
  name    = "www.${var.domain_name}.co.uk"
  type    = "A"

  alias {
    name                   = "${var.wp_elb_dns_name}"
    zone_id                = "${var.wp_elb_zone_id}"
    evaluate_target_health = false
  }
}

#dev 

resource "aws_route53_record" "dev" {
  zone_id = "${aws_route53_zone.primary.zone_id}"
  name    = "dev.${var.domain_name}.co.uk"
  type    = "A"
  ttl     = "300"
  records = ["${var.wp_dev_public_ip}"]
}

#secondary zone

resource "aws_route53_zone" "secondary" {
  name = "${var.domain_name}.co.uk"

  vpc {
    vpc_id = "${var.wp_vpc_id}"
  }
}

#db 

resource "aws_route53_record" "db" {
  zone_id = "${aws_route53_zone.secondary.zone_id}"
  name    = "db.${var.domain_name}.co.uk"
  type    = "CNAME"
  ttl     = "300"
  records = ["${var.wp_db_address}"]
}
