data "aws_caller_identity" "current" {}

locals {
  # Hosted zones looked up for Amazon-issued certificates that create Route53 records. Key: acm_parameters key (domain name).
  route53_zone_enabled = {
    for acm_key, acm_config in var.acm_parameters :
    acm_key => (
      try(acm_config.certificate_source, var.acm_defaults.certificate_source, "amazon") == "amazon" &&
      try(acm_config.create_route53_records, var.acm_defaults.create_route53_records, true) != false
    )
  }

  route53_zone_calculated = {
    for acm_key, acm_config in var.acm_parameters :
    acm_key => {
      "private_zone" = try(acm_config.private_zone, false)
    } if local.route53_zone_enabled[acm_key]
  }
}

# for_each key: acm_parameters key (domain name) for Amazon-issued certificates that create Route53 records.
data "aws_route53_zone" "this" {
  for_each = local.route53_zone_calculated

  name         = each.key
  private_zone = false
}