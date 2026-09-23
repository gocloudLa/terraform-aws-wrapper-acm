module "wrapper_acm" {
  source = "../../"

  providers = {
    aws.use1 = aws.use1
  }

  metadata = local.metadata

  acm_parameters = {
    "${local.zone_public}" = {
      subject_alternative_names = [
        "*.${local.zone_public}"
      ]
    }

    "gcl-example.com" = {
      subject_alternative_names = [
        "*.gcl-example.com"
      ]
      # EXTERNAL DNS SERVER
      create_route53_records = false
      validate_certificate   = false
    }

    "mail.gcl-example.com" = {
      validation_method = "EMAIL"
      validation_option = {
        "mail.gcl-example.com" = {
          validation_domain = "gcl-example.com"
        }
      }
      create_route53_records = false
      # Default: true. The lab does not approve the validation email.
      wait_for_validation = false
    }

    "internal.gcl-example.com" = {
      certificate_source = "self_signed"
      subject_alternative_names = [
        "*.internal.gcl-example.com"
      ]
    }

    # "imported.gcl-example.com" = {
    #   certificate_source = "import"
    #   certificate_body   = file("${path.module}/certs/imported.crt")
    #   private_key        = file("${path.module}/certs/imported.key")
    #   certificate_chain  = file("${path.module}/certs/chain.crt")
    # }
  }

  acm_defaults = var.acm_defaults
}