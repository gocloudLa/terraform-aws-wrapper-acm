# Standard Platform - Terraform Module 🚀🚀
<p align="right"><a href="https://partners.amazonaws.com/partners/0018a00001hHve4AAC/GoCloud"><img src="https://img.shields.io/badge/AWS%20Partner-Advanced-orange?style=for-the-badge&logo=amazonaws&logoColor=white" alt="AWS Partner"/></a><a href="LICENSE"><img src="https://img.shields.io/badge/License-Apache%202.0-green?style=for-the-badge&logo=apache&logoColor=white" alt="LICENSE"/></a></p>

Welcome to the Standard Platform — a suite of reusable and production-ready Terraform modules purpose-built for AWS environments.
Each module encapsulates best practices, security configurations, and sensible defaults to simplify and standardize infrastructure provisioning across projects.

## 📦 Module: Terraform ACM Module
<p align="right"><a href="https://github.com/gocloudLa/terraform-aws-wrapper-acm/releases/latest"><img src="https://img.shields.io/github/v/release/gocloudLa/terraform-aws-wrapper-acm.svg?style=for-the-badge" alt="Latest Release"/></a><a href=""><img src="https://img.shields.io/github/last-commit/gocloudLa/terraform-aws-wrapper-acm.svg?style=for-the-badge" alt="Last Commit"/></a><a href="https://registry.terraform.io/modules/gocloudLa/wrapper-acm/aws"><img src="https://img.shields.io/badge/Terraform-Registry-7B42BC?style=for-the-badge&logo=terraform&logoColor=white" alt="Terraform Registry"/></a></p>
Issues Amazon ACM certificates and validates them with Route53 or email, imports a PEM certificate you already have, or generates a self-signed certificate and stores it in ACM.


### ✨ Features

- 🔐 [Amazon-issued certificate](#amazon-issued-certificate) - Request a public or private ACM certificate and validate it with Route53 or email.

- 📥 [Import an existing certificate](#import-an-existing-certificate) - Upload a PEM certificate and private key that already exist on your machine.

- 🧪 [Self-signed certificate](#self-signed-certificate) - Generate a certificate in Terraform and import it into ACM.




## 🚀 Quick Start
```hcl
acm_parameters = {
  "${local.zone_public}" = {
    subject_alternative_names = [
      "*.${local.zone_public}"
    ]

    # key_algorithm = "RSA_2048"
    # create_acm_us_east_1 = true
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
    # Lab: do not wait for the approval email.
    wait_for_validation = false
  }

  "internal.gcl-example.com" = {
    certificate_source = "self_signed"
    subject_alternative_names = [
      "*.internal.gcl-example.com"
    ]

    # key_algorithm                     = "RSA_2048"
    # self_signed_validity_period_hours = 8760
    # self_signed_subject = {
    #   organization        = "Example Inc"
    #   organizational_unit = "Platform"
    #   country             = "AR"
    #   locality            = "Buenos Aires"
    #   province            = "Buenos Aires"
    #   street_address      = ["Example 123"]
    #   postal_code         = "C1000"
    # }
  }

  # "imported.gcl-example.com" = {
  #   certificate_source = "import"
  #   certificate_body   = file("${path.module}/certs/imported.crt")
  #   private_key        = file("${path.module}/certs/imported.key")
  #   certificate_chain  = file("${path.module}/certs/chain.crt")
  # }
}
```


## 🔧 Additional Features Usage

### Amazon-issued certificate
The default path requests `aws_acm_certificate` from Amazon, or from a private CA when `private_authority_arn` is set. DNS validation creates `aws_route53_record` and waits with `aws_acm_certificate_validation`. Set `validation_method` to `EMAIL` and `validation_option` when ACM should send the approval message instead of using DNS. A second certificate is created in us-east-1 when the stack region is not us-east-1.


<details><summary>Public certificate with a wildcard</summary>

```hcl
acm_parameters = {
  "example.com" = {
    subject_alternative_names = [
      "*.example.com"
    ]

    # key_algorithm = "RSA_2048"
    # create_acm_us_east_1 = true
  }
}
```


</details>

<details><summary>Email validation</summary>

```hcl
acm_parameters = {
  "mail.example.com" = {
    validation_method = "EMAIL"
    validation_option = {
      "mail.example.com" = {
        validation_domain = "example.com"
      }
    }
    create_route53_records = false
    # wait_for_validation = true
  }
}
```


</details>


### Import an existing certificate
Set `certificate_source` to `import` and pass `certificate_body` and `private_key`. `certificate_chain` is optional. ACM reads the domain names from the certificate, so this path does not create Route53 validation records. Use the same PEM on the us-east-1 certificate when both regions must serve one certificate.


<details><summary>PEM files on disk</summary>

```hcl
acm_parameters = {
  "imported.example.com" = {
    certificate_source = "import"
    certificate_body   = file("${path.module}/certs/imported.crt")
    private_key        = file("${path.module}/certs/imported.key")
    # certificate_chain = file("${path.module}/certs/chain.crt")
  }
}
```


</details>


### Self-signed certificate
Set `certificate_source` to `self_signed`. The module creates a private key and certificate, then imports that PEM into ACM. `domain_name` is the common name and `subject_alternative_names` are added as DNS names. Each region receives its own key pair.


<details><summary>Internal wildcard</summary>

```hcl
acm_parameters = {
  "internal.example.com" = {
    certificate_source = "self_signed"
    subject_alternative_names = [
      "*.internal.example.com"
    ]

    # key_algorithm                     = "RSA_2048"
    # self_signed_validity_period_hours = 8760
    # self_signed_subject = {
    #   organization        = "Example Inc"
    #   organizational_unit = "Platform"
    #   country             = "AR"
    #   locality            = "Buenos Aires"
    #   province            = "Buenos Aires"
    #   street_address      = ["Example 123"]
    #   postal_code         = "C1000"
    # }
  }
}
```


</details>




## 📑 Inputs
| Name                                        | Description                                                                                                                                                 | Type     | Default                                                    | Required |
| ------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ---------------------------------------------------------- | -------- |
| certificate_source                          | Certificate origin. Valid values are amazon, import, and self_signed.                                                                                       | `string` | `"amazon"`                                                 | no       |
| domain_name                                 | The primary domain name for the certificate.                                                                                                                | `string` | `each.key`                                                 | no       |
| subject_alternative_names                   | A list of alternative domain names for the certificate.                                                                                                     | `list`   | `[]`                                                       | no       |
| zone_id                                     | Route53 hosted zone ID for domain validation.                                                                                                               | `string` | `null`                                                     | no       |
| zones                                       | Map of additional domain names to Route53 hosted zone IDs.                                                                                                  | `map`    | `{}`                                                       | no       |
| private_authority_arn                       | Private Certificate Authority ARN for issuing private certificates.                                                                                         | `string` | `null`                                                     | no       |
| region                                      | Region to create the resources into.                                                                                                                        | `string` | `null`                                                     | no       |
| create_certificate                          | Determines if a new certificate should be created.                                                                                                          | `bool`   | `true`                                                     | no       |
| create_route53_records_only                 | Specifies if only Route53 records should be created without a certificate.                                                                                  | `bool`   | `false`                                                    | no       |
| create_acm_us_east_1                        | Specifies if a new certificate should be created in us-east-1 region.                                                                                       | `bool`   | `true`                                                     | no       |
| validate_certificate                        | Enables validation for the created certificate.                                                                                                             | `bool`   | `true`                                                     | no       |
| validation_allow_overwrite_records          | Allows overwriting existing DNS records during validation.                                                                                                  | `bool`   | `true`                                                     | no       |
| wait_for_validation                         | Waits for the certificate validation to complete.                                                                                                           | `bool`   | `true`                                                     | no       |
| create_route53_records                      | Whether to create Route53 records for the certificate.                                                                                                      | `bool`   | `true`                                                     | no       |
| certificate_transparency_logging_preference | Enables or disables certificate transparency logging.                                                                                                       | `bool`   | `true`                                                     | no       |
| private_key                                 | PEM-encoded private key. Required when certificate_source is import.                                                                                        | `string` | `null`                                                     | no       |
| certificate_body                            | PEM-encoded certificate body. Required when certificate_source is import.                                                                                   | `string` | `null`                                                     | no       |
| certificate_chain                           | PEM-encoded certificate chain of an imported certificate.                                                                                                   | `string` | `null`                                                     | no       |
| validation_method                           | The method used for domain validation (DNS or EMAIL).                                                                                                       | `string` | `"DNS"`                                                    | no       |
| validation_option                           | Map of certificate domain name to validation_domain. Used when validation_method is EMAIL.                                                                  | `map`    | `{}`                                                       | no       |
| validation_record_fqdns                     | List of fully qualified domain names (FQDNs) for validation records.                                                                                        | `list`   | `[]`                                                       | no       |
| validation_timeout                          | Timeout period for certificate validation.                                                                                                                  | `string` | `null`                                                     | no       |
| dns_ttl                                     | Time-to-live (TTL) for DNS validation records.                                                                                                              | `number` | `60`                                                       | no       |
| key_algorithm                               | Key algorithm. Valid values are RSA_2048, RSA_4096, EC_prime256v1, and EC_secp384r1.                                                                        | `string` | `"RSA_2048"`                                               | no       |
| export                                      | Whether the certificate can be exported. Valid values are ENABLED or DISABLED.                                                                              | `string` | `null`                                                     | no       |
| self_signed_validity_period_hours           | Number of hours a self-signed certificate remains valid.                                                                                                    | `number` | `8760`                                                     | no       |
| self_signed_early_renewal_hours             | Hours before expiry when Terraform renews a self-signed certificate.                                                                                        | `number` | `720`                                                      | no       |
| self_signed_allowed_uses                    | Allowed key usages of a self-signed certificate.                                                                                                            | `list`   | `["key_encipherment", "digital_signature", "server_auth"]` | no       |
| self_signed_subject                         | Self-signed subject. Keys: organization, organizational_unit, country, locality, province, street_address, postal_code. common_name comes from domain_name. | `object` | `{}`                                                       | no       |
| acm_certificate_domain_validation_options   | ACM certificate domain validation options.                                                                                                                  | `map`    | `{}`                                                       | no       |
| distinct_domain_names                       | List of distinct domain names for the certificate.                                                                                                          | `list`   | `[]`                                                       | no       |
| tags                                        | A map of tags to assign to resources.                                                                                                                       | `map`    | `{}`                                                       | no       |







## ⚠️ Important Notes
- 🔒 **Private keys in state:** `private_key`, `certificate_body`, `certificate_chain`, and the key of a self-signed certificate are stored in Terraform state.
- ⚠️ **No ACM renewal:** ACM does not renew imported or self-signed certificates. A self-signed certificate is recreated `self_signed_early_renewal_hours` before it expires (default 720) and the ACM import is updated.
- ℹ️ **Self-signed trust:** Self-signed certificates are not publicly trusted. Use them for internal or laboratory workloads.
- ⚠️ **Email validation:** ACM emails the addresses of `validation_domain`. Apply waits for that approval while `wait_for_validation` is true.
- ℹ️ **Same PEM in two regions:** The us-east-1 certificate is a separate ACM object. Self-signed mode generates a second key pair there. Import the same PEM when both regions must present one certificate.



---

## 🤝 Contributing
We welcome contributions! Please see our contributing guidelines for more details.

## 🆘 Support
- 📧 **Email**: info@gocloud.la

## 🧑‍💻 About
We are focused on Cloud Engineering, DevOps, and Infrastructure as Code.
We specialize in helping companies design, implement, and operate secure and scalable cloud-native platforms.
- 🌎 [www.gocloud.la](https://www.gocloud.la)
- ☁️ AWS Advanced Partner (Terraform, DevOps, GenAI)
- 📫 Contact: info@gocloud.la

## 📄 License
This project is licensed under the Apache 2.0 License - see the [LICENSE](LICENSE) file for details. 