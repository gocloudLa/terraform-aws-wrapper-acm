locals {
  create_amazon               = var.create_certificate && var.certificate_source == "amazon"
  create_self_signed          = var.create_certificate && var.certificate_source == "self_signed"
  create_imported             = var.create_certificate && contains(["import", "self_signed"], var.certificate_source)
  create_route53_records_only = var.create_route53_records_only && var.certificate_source == "amazon"

  # Distinct registrable names used to address Route53 validation records. Wildcard labels are stripped.
  distinct_domain_names = coalescelist(var.distinct_domain_names, distinct([
    for s in concat([var.domain_name], var.subject_alternative_names) : replace(s, "*.", "")
  ]))

  validation_domains = local.create_amazon || local.create_route53_records_only ? distinct([
    for _, v in try(aws_acm_certificate.this[0].domain_validation_options, var.acm_certificate_domain_validation_options) : merge(
      tomap(v),
      { domain_name = replace(v.domain_name, "*.", "") }
    )
  ]) : []

  # ACM key_algorithm values mapped to the tls provider. Key: ACM algorithm.
  tls_algorithms = {
    RSA_2048 = {
      algorithm   = "RSA"
      rsa_bits    = 2048
      ecdsa_curve = null
    }
    RSA_4096 = {
      algorithm   = "RSA"
      rsa_bits    = 4096
      ecdsa_curve = null
    }
    EC_prime256v1 = {
      algorithm   = "ECDSA"
      rsa_bits    = null
      ecdsa_curve = "P256"
    }
    EC_secp384r1 = {
      algorithm   = "ECDSA"
      rsa_bits    = null
      ecdsa_curve = "P384"
    }
  }

  self_signed_key_algorithm = coalesce(var.key_algorithm, "RSA_2048")
  tls_key_spec              = try(local.tls_algorithms[local.self_signed_key_algorithm], null)
}

resource "terraform_data" "validate" {
  input = var.certificate_source

  lifecycle {
    precondition {
      condition = var.certificate_source != "import" || !var.create_certificate || (
        var.private_key != null && var.private_key != "" && var.certificate_body != null && var.certificate_body != ""
      )
      error_message = "certificate_source import requires private_key and certificate_body."
    }

    precondition {
      condition = !contains(["amazon", "self_signed"], var.certificate_source) || (
        (var.private_key == null || var.private_key == "") &&
        (var.certificate_body == null || var.certificate_body == "") &&
        (var.certificate_chain == null || var.certificate_chain == "")
      )
      error_message = "private_key, certificate_body, and certificate_chain are only set when certificate_source is import."
    }

    precondition {
      condition = var.certificate_source != "self_signed" || !var.create_certificate || (
        var.domain_name != "" && local.tls_key_spec != null
      )
      error_message = "self_signed requires domain_name and a key_algorithm of RSA_2048, RSA_4096, EC_prime256v1, or EC_secp384r1."
    }
  }
}

resource "tls_private_key" "this" {
  count = local.create_self_signed ? 1 : 0

  algorithm   = local.tls_key_spec != null ? local.tls_key_spec.algorithm : "RSA"
  rsa_bits    = local.tls_key_spec != null ? local.tls_key_spec.rsa_bits : null
  ecdsa_curve = local.tls_key_spec != null ? local.tls_key_spec.ecdsa_curve : null
}

resource "tls_self_signed_cert" "this" {
  count = local.create_self_signed ? 1 : 0

  private_key_pem       = tls_private_key.this[0].private_key_pem
  validity_period_hours = var.self_signed_validity_period_hours
  early_renewal_hours   = var.self_signed_early_renewal_hours
  allowed_uses          = var.self_signed_allowed_uses
  dns_names             = distinct(compact(concat([var.domain_name], var.subject_alternative_names)))

  subject {
    common_name         = var.domain_name
    organization        = var.self_signed_subject.organization
    organizational_unit = var.self_signed_subject.organizational_unit
    country             = var.self_signed_subject.country
    locality            = var.self_signed_subject.locality
    province            = var.self_signed_subject.province
    street_address      = var.self_signed_subject.street_address
    postal_code         = var.self_signed_subject.postal_code
  }
}

resource "aws_acm_certificate" "this" {
  count = local.create_amazon ? 1 : 0

  domain_name               = var.domain_name
  subject_alternative_names = var.subject_alternative_names
  validation_method         = var.validation_method
  key_algorithm             = var.key_algorithm
  region                    = var.region
  certificate_authority_arn = var.private_authority_arn

  options {
    certificate_transparency_logging_preference = var.certificate_transparency_logging_preference ? "ENABLED" : "DISABLED"
    export                                      = var.export
  }

  dynamic "validation_option" {
    for_each = var.validation_option

    content {
      domain_name       = try(validation_option.value["domain_name"], validation_option.key)
      validation_domain = validation_option.value["validation_domain"]
    }
  }

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate" "imported" {
  count = local.create_imported ? 1 : 0

  private_key       = local.create_self_signed ? tls_private_key.this[0].private_key_pem : var.private_key
  certificate_body  = local.create_self_signed ? tls_self_signed_cert.this[0].cert_pem : var.certificate_body
  certificate_chain = local.create_self_signed ? null : var.certificate_chain
  region            = var.region
  tags              = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

# for_each is not used: records are addressed by index of distinct_domain_names (wildcard prefix removed).
resource "aws_route53_record" "validation" {
  count = (local.create_amazon || local.create_route53_records_only) && var.validation_method == "DNS" && var.create_route53_records && (var.validate_certificate || local.create_route53_records_only) ? length(local.distinct_domain_names) : 0

  zone_id = try(var.zones[element(local.validation_domains, count.index)["domain_name"]], var.zone_id)
  name    = element(local.validation_domains, count.index)["resource_record_name"]
  type    = element(local.validation_domains, count.index)["resource_record_type"]
  ttl     = var.dns_ttl

  records = [
    element(local.validation_domains, count.index)["resource_record_value"]
  ]

  allow_overwrite = var.validation_allow_overwrite_records

  depends_on = [aws_acm_certificate.this]
}

resource "aws_acm_certificate_validation" "this" {
  count = local.create_amazon && var.validation_method != null && var.validate_certificate && var.wait_for_validation ? 1 : 0

  certificate_arn         = aws_acm_certificate.this[0].arn
  region                  = var.region
  validation_record_fqdns = flatten([aws_route53_record.validation[*].fqdn, var.validation_record_fqdns])

  timeouts {
    create = var.validation_timeout
  }
}
