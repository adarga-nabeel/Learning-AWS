data "aws_route53_zone" "selected" {
  count        = var.update_hosted_zone == true && var.domain_name != "" ? 1 : 0
  name         = var.domain_name
  private_zone = true
}

resource "aws_route53_record" "www" {
  count   = var.update_hosted_zone == true ? 1 : 0
  zone_id = data.aws_route53_zone.selected[count.index].zone_id
  name    = data.aws_route53_zone.selected[count.index].name
  type    = "A"
  ttl     = 300
  records = [aws_eip.main.public_ip]
}