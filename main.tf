module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "6.0.0"

  for_each = var.acm_parameters

  create_certificate                          = true
  create_route53_records_only                 = try(each.value.create_route53_records_only, var.acm_defaults.create_route53_records_only, false)
  validate_certificate                        = try(each.value.validate_certificate, var.acm_defaults.validate_certificate, true)
  validation_allow_overwrite_records          = try(each.value.validation_allow_overwrite_records, var.acm_defaults.validation_allow_overwrite_records, true)
  wait_for_validation                         = try(each.value.wait_for_validation, var.acm_defaults.wait_for_validation, true)
  certificate_transparency_logging_preference = try(each.value.certificate_transparency_logging_preference, var.acm_defaults.certificate_transparency_logging_preference, true)
  domain_name                                 = try(each.value.domain_name, var.acm_defaults.domain_name, each.key)
  subject_alternative_names                   = try(each.value.subject_alternative_names, var.acm_defaults.subject_alternative_names, [])
  validation_method                           = try(each.value.validation_method, var.acm_defaults.validation_method, "DNS")
  validation_option                           = try(each.value.validation_option, var.acm_defaults.validation_option, {})
  create_route53_records                      = try(each.value.create_route53_records, var.acm_defaults.create_route53_records, true)
  validation_record_fqdns                     = try(each.value.validation_record_fqdns, var.acm_defaults.validation_record_fqdns, [])
  zone_id                                     = try(each.value.zone_id, var.acm_defaults.zone_id, data.aws_route53_zone.this[each.key].zone_id, null)
  dns_ttl                                     = try(each.value.dns_ttl, var.acm_defaults.dns_ttl, 60)
  acm_certificate_domain_validation_options   = try(each.value.acm_certificate_domain_validation_options, var.acm_defaults.acm_certificate_domain_validation_options, {})
  distinct_domain_names                       = try(each.value.distinct_domain_names, var.acm_defaults.distinct_domain_names, [])
  validation_timeout                          = try(each.value.validation_timeout, var.acm_defaults.validation_timeout, null)
  key_algorithm                               = try(each.value.key_algorithm, var.acm_defaults.key_algorithm, "RSA_2048")
  zones                                       = try(each.value.zones, var.acm_defaults.zones, {})
  region                                      = try(each.value.region, var.acm_defaults.region, null)
  private_authority_arn                       = try(each.value.private_authority_arn, var.acm_defaults.private_authority_arn, null)

  tags = local.common_tags
}

module "acm_secondary" {
  source  = "terraform-aws-modules/acm/aws"
  version = "6.0.0"

  for_each = var.acm_parameters

  create_certificate                          = local.metadata.aws_region == "us-east-1" ? false : true
  create_route53_records_only                 = try(each.value.create_route53_records_only, var.acm_defaults.create_route53_records_only, false)
  validate_certificate                        = try(each.value.validate_certificate, var.acm_defaults.validate_certificate, true)
  validation_allow_overwrite_records          = try(each.value.validation_allow_overwrite_records, var.acm_defaults.validation_allow_overwrite_records, true)
  wait_for_validation                         = try(each.value.wait_for_validation, var.acm_defaults.wait_for_validation, true)
  certificate_transparency_logging_preference = try(each.value.certificate_transparency_logging_preference, var.acm_defaults.certificate_transparency_logging_preference, true)
  domain_name                                 = try(each.value.domain_name, var.acm_defaults.domain_name, each.key)
  subject_alternative_names                   = try(each.value.subject_alternative_names, var.acm_defaults.subject_alternative_names, [])
  validation_method                           = try(each.value.validation_method, var.acm_defaults.validation_method, "DNS")
  validation_option                           = try(each.value.validation_option, var.acm_defaults.validation_option, {})
  create_route53_records                      = try(each.value.create_route53_records, var.acm_defaults.create_route53_records, true)
  validation_record_fqdns                     = try(each.value.validation_record_fqdns, var.acm_defaults.validation_record_fqdns, [])
  zone_id                                     = try(each.value.zone_id, var.acm_defaults.zone_id, data.aws_route53_zone.this[each.key].zone_id, null)
  dns_ttl                                     = try(each.value.dns_ttl, var.acm_defaults.dns_ttl, 60)
  acm_certificate_domain_validation_options   = try(each.value.acm_certificate_domain_validation_options, var.acm_defaults.acm_certificate_domain_validation_options, {})
  distinct_domain_names                       = try(each.value.distinct_domain_names, var.acm_defaults.distinct_domain_names, [])
  validation_timeout                          = try(each.value.validation_timeout, var.acm_defaults.validation_timeout, null)
  key_algorithm                               = try(each.value.key_algorithm, var.acm_defaults.key_algorithm, "RSA_2048")
  zones                                       = try(each.value.zones, var.acm_defaults.zones, {})
  region                                      = try(each.value.region, var.acm_defaults.region, null)
  private_authority_arn                       = try(each.value.private_authority_arn, var.acm_defaults.private_authority_arn, null)


  tags = local.common_tags

  providers = {
    aws = aws.use1
  }
}