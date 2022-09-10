resource "aws_route53_record" "metrics" {
  zone_id = "Z07962563NKNUV1C86GSU"
  name    = "metrics.valwitter.com"
  type    = "CNAME"
  ttl     = 300
  records = [var.lb_dns]
}