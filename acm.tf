locals {
  acm_domain_names = length(var.acm_domain_names) > 0 ? var.acm_domain_names : var.enable_acm_for_domain_names ? var.domain_names : []
}

data "aws_acm_certificate" "this" {
  for_each    = toset(local.acm_domain_names)
  domain      = each.value
  most_recent = true
  statuses    = ["ISSUED"]
}

resource "aws_lb_listener_certificate" "this" {
  for_each        = { for k, v in data.aws_acm_certificate.this : k => v.arn }
  certificate_arn = each.value
  listener_arn    = var.lb_listener_arn
}
