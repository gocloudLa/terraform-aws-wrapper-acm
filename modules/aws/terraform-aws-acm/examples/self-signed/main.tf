module "acm" {
  source = "../../"

  certificate_source = "self_signed"
  domain_name        = var.domain_name

  subject_alternative_names = [
    "*.${var.domain_name}"
  ]

  # Default: 8760
  # self_signed_validity_period_hours = 8760
}
