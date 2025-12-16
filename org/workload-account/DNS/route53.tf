############################################################
# DNS (ROUTE 53)
############################################################

resource "aws_route53_zone" "primary" {
  name = "pilotgabapp.com"
}

resource "aws_route53_record" "app" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www.pilotgabapp.com"
  type    = "A"

  alias {
    name                   = aws_lb.public.dns_name
    zone_id                = aws_lb.public.zone_id
    evaluate_target_health = true
  }
}
