variable "domain_name" {}
variable "lb_zone_id" {}
variable "lb_dns_name" {}


output "certificate_arn" {
    value = aws_acm_certificate.certificate.arn  
}

data "aws_route53_zone" "route53_zone" {
  name = var.domain_name
}

output "hosted_zone_id" {
  value = data.aws_route53_zone.route53_zone.zone_id
}

output "certificate_validation" {
    value = aws_acm_certificate_validation.certificate_validation
}


resource "aws_route53_record" "zone_record" {
    zone_id = data.aws_route53_zone.route53_zone.zone_id
    name    = var.domain_name
    type    = "A"

    alias {
        name                   = var.lb_dns_name
        zone_id                = var.lb_zone_id
        evaluate_target_health = true
    }
}

resource "aws_acm_certificate" "certificate" {
    depends_on = [ aws_route53_record.zone_record ]
    domain_name       = var.domain_name
    validation_method = "DNS"

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_route53_record" "validation_record" {
  for_each = {
    for dvo in aws_acm_certificate.certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.route53_zone.zone_id
}


resource "aws_acm_certificate_validation" "certificate_validation" {
  depends_on = [ aws_acm_certificate.certificate, aws_route53_record.validation_record, aws_route53_record.zone_record]
   for_each                = { for dvo in aws_acm_certificate.certificate.domain_validation_options : dvo.domain_name => dvo }
   certificate_arn         = aws_acm_certificate.certificate.arn
   validation_record_fqdns = [aws_route53_record.validation_record[each.key].fqdn]
}