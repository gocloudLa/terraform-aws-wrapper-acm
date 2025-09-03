# Standard Platform - Terraform Module 🚀🚀
<p align="right"><a href="https://partners.amazonaws.com/partners/0018a00001hHve4AAC/GoCloud"><img src="https://img.shields.io/badge/AWS%20Partner-Advanced-orange?style=for-the-badge&logo=amazonaws&logoColor=white" alt="AWS Partner"/></a><a href="LICENSE"><img src="https://img.shields.io/badge/License-Apache%202.0-green?style=for-the-badge&logo=apache&logoColor=white" alt="LICENSE"/></a></p>

Welcome to the Standard Platform — a suite of reusable and production-ready Terraform modules purpose-built for AWS environments.
Each module encapsulates best practices, security configurations, and sensible defaults to simplify and standardize infrastructure provisioning across projects.

## 📦 Module: Terraform ACM SSL Module
<p align="right"><a href="https://github.com/gocloudLa/terraform-aws-wrapper-acm/releases/latest"><img src="https://img.shields.io/github/v/release/gocloudLa/terraform-aws-wrapper-acm.svg?style=for-the-badge" alt="Latest Release"/></a><a href=""><img src="https://img.shields.io/github/last-commit/gocloudLa/terraform-aws-wrapper-acm.svg?style=for-the-badge" alt="Last Commit"/></a><a href="https://registry.terraform.io/modules/gocloudLa/wrapper-acm/aws"><img src="https://img.shields.io/badge/Terraform-Registry-7B42BC?style=for-the-badge&logo=terraform&logoColor=white" alt="Terraform Registry"/></a></p>
The Terraform Wrapper for ACM simplifies the configuration of the SSL Certificate Service in the AWS cloud. This wrapper functions as a predefined template, facilitating the creation and management of ACM by handling all the technical details.

### ✨ Features



### 🔗 External Modules
| Name | Version |
|------|------:|
| <a href="https://github.com/terraform-aws-modules/terraform-aws-acm" target="_blank">terraform-aws-modules/acm/aws</a> | 6.0.0 |



## 🚀 Quick Start
```hcl
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
  }
  }

  acm_defaults = var.acm_defaults
```


## 🔧 Additional Features Usage



## 📑 Inputs
| Name                                        | Description                                                                | Type     | Default      | Required |
| ------------------------------------------- | -------------------------------------------------------------------------- | -------- | ------------ | -------- |
| create_certificate                          | Determines if a new certificate should be created.                         | `bool`   | `true`       | no       |
| create_route53_records_only                 | Specifies if only Route53 records should be created without a certificate. | `bool`   | `false`      | no       |
| validate_certificate                        | Enables validation for the created certificate.                            | `bool`   | `true`       | no       |
| validation_allow_overwrite_records          | Allows overwriting existing DNS records during validation.                 | `bool`   | `true`       | no       |
| wait_for_validation                         | Waits for the certificate validation to complete.                          | `bool`   | `true`       | no       |
| certificate_transparency_logging_preference | Enables or disables certificate transparency logging.                      | `bool`   | `true`       | no       |
| domain_name                                 | The primary domain name for the certificate.                               | `string` | `each.key`   | no       |
| subject_alternative_names                   | A list of alternative domain names for the certificate.                    | `list`   | `[]`         | no       |
| validation_method                           | The method used for domain validation (DNS or EMAIL).                      | `string` | `"DNS"`      | no       |
| validation_option                           | Custom options for validation.                                             | `null`   | `{}`         | no       |
| create_route53_records                      | Whether to create Route53 records for the certificate.                     | `bool`   | `true`       | no       |
| validation_record_fqdns                     | List of fully qualified domain names (FQDNs) for validation records.       | `list`   | `[]`         | no       |
| zone_id                                     | Route53 hosted zone ID for domain validation.                              | `string` | `null`       | no       |
| dns_ttl                                     | Time-to-live (TTL) for DNS validation records.                             | `number` | `60`         | no       |
| acm_certificate_domain_validation_options   | ACM certificate domain validation options.                                 | `null`   | `{}`         | no       |
| distinct_domain_names                       | List of distinct domain names for the certificate.                         | `list`   | `[]`         | no       |
| validation_timeout                          | Timeout period for certificate validation in seconds.                      | `number` | `null`       | no       |
| key_algorithm                               | The cryptographic key algorithm for the certificate.                       | `string` | `"RSA_2048"` | no       |
| private_authority_arn                       | Private Certificate Authority ARN for issuing private certificates.        | `string` | `null`       | no       |
| region                                      | Region to create the resources into.                                       | `string` | `null`       | no       |








---

## 🤝 Contributing
We welcome contributions! Please see our contributing guidelines for more details.

## 🆘 Support
- 📧 **Email**: info@gocloud.la
- 🐛 **Issues**: [GitHub Issues](https://github.com/gocloudLa/issues)

## 🧑‍💻 About
We are focused on Cloud Engineering, DevOps, and Infrastructure as Code.
We specialize in helping companies design, implement, and operate secure and scalable cloud-native platforms.
- 🌎 [www.gocloud.la](https://www.gocloud.la)
- ☁️ AWS Advanced Partner (Terraform, DevOps, GenAI)
- 📫 Contact: info@gocloud.la

## 📄 License
This project is licensed under the Apache 2.0 License - see the [LICENSE](LICENSE) file for details. 