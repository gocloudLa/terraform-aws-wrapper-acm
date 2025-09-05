data "aws_caller_identity" "current" {}

locals {
  route53_zone_calculated = {
    for acm_key, acm_config in var.acm_parameters :
    acm_key => {
      "private_zone" = try(acm_config.private_zone, false)
    } if(try(acm_config.create_route53_records, true) != false)
  }
}

data "aws_route53_zone" "this" {
  for_each = local.route53_zone_calculated

  name         = each.key
  private_zone = false
}