data "aws_route53_zone" "main_zone" {
  name         = "ragedunicorn.com."
  private_zone = false
}

resource "aws_route53_record" "dns" {
  zone_id = "${data.aws_route53_zone.main_zone.zone_id}"
  name    = "wow-vanilla"
  type    = "A"
  ttl     = "300"
  records = ["${aws_eip.elastic_ip.public_ip}"]
}
