variable "create_certificate" {
  description = "Whether to create an ACM certificate."
  type        = bool
  default     = true
}

variable "create_route53_records_only" {
  description = "Whether to create only Route53 records, for example from a separate AWS provider."
  type        = bool
  default     = false
}

variable "validate_certificate" {
  description = "Whether to validate the certificate by creating the Route53 record."
  type        = bool
  default     = true
}

variable "validation_allow_overwrite_records" {
  description = "Whether to allow overwrite of existing Route53 records."
  type        = bool
  default     = true
}

variable "wait_for_validation" {
  description = "Whether to wait for certificate validation to complete."
  type        = bool
  default     = true
}

variable "validation_timeout" {
  description = "Maximum time to wait for certificate validation to complete."
  type        = string
  default     = null
}

variable "certificate_transparency_logging_preference" {
  description = "Whether certificate details are added to a certificate transparency log."
  type        = bool
  default     = true
}

variable "domain_name" {
  description = "Domain name for which the certificate should be issued."
  type        = string
  default     = ""
}

variable "region" {
  description = "Region where the ACM resources are created."
  type        = string
  default     = null
}

variable "subject_alternative_names" {
  description = "Additional domain names included as subject alternative names."
  type        = list(string)
  default     = []
}

variable "validation_method" {
  description = "Validation method. Valid values are DNS, EMAIL, or null. Must be null for imported certificates."
  type        = string
  default     = null

  validation {
    condition     = var.validation_method == null || contains(["DNS", "EMAIL"], coalesce(var.validation_method, "DNS"))
    error_message = "Valid values are DNS, EMAIL, or null."
  }
}

variable "validation_option" {
  description = "Domain names ACM uses as the suffix of validation email addresses."
  type        = any
  default     = {}
}

variable "create_route53_records" {
  description = "Whether DNS validation records are created in Route53."
  type        = bool
  default     = true
}

variable "validation_record_fqdns" {
  description = "FQDNs of DNS validation records created outside this module."
  type        = list(string)
  default     = []
}

variable "zone_id" {
  description = "Route53 hosted zone ID that contains the validation records."
  type        = string
  default     = ""
}

variable "zones" {
  description = "Route53 hosted zone IDs for additional domain names."
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags assigned to the certificate."
  type        = map(string)
  default     = {}
}

variable "dns_ttl" {
  description = "TTL of the DNS validation records."
  type        = number
  default     = 60
}

variable "acm_certificate_domain_validation_options" {
  description = "Domain validation options used when create_route53_records_only is true."
  type        = any
  default     = {}
}

variable "distinct_domain_names" {
  description = "Distinct domains and subject alternative names used when create_route53_records_only is true."
  type        = list(string)
  default     = []
}

variable "key_algorithm" {
  description = "Algorithm of the public and private key pair. Valid values are RSA_2048, RSA_4096, EC_prime256v1, and EC_secp384r1."
  type        = string
  default     = null
}

variable "export" {
  description = "Whether the certificate can be exported. Valid values are ENABLED or DISABLED."
  type        = string
  default     = null
}

variable "private_authority_arn" {
  description = "ARN of the ACM Private Certificate Authority that issues the certificate."
  type        = string
  default     = null
}

variable "certificate_source" {
  description = "Certificate origin. Valid values are amazon, import, and self_signed."
  type        = string
  default     = "amazon"

  validation {
    condition     = contains(["amazon", "import", "self_signed"], var.certificate_source)
    error_message = "Valid values are amazon, import, or self_signed."
  }
}

variable "private_key" {
  description = "PEM-encoded private key. Required when certificate_source is import."
  type        = string
  default     = null
  sensitive   = true
}

variable "certificate_body" {
  description = "PEM-encoded certificate body. Required when certificate_source is import."
  type        = string
  default     = null
  sensitive   = true
}

variable "certificate_chain" {
  description = "PEM-encoded certificate chain of an imported certificate."
  type        = string
  default     = null
  sensitive   = true
}

variable "self_signed_validity_period_hours" {
  description = "Number of hours a self-signed certificate remains valid."
  type        = number
  default     = 8760
}

variable "self_signed_early_renewal_hours" {
  description = "Hours before expiry when Terraform renews a self-signed certificate."
  type        = number
  default     = 720
}

variable "self_signed_allowed_uses" {
  description = "Allowed key usages of a self-signed certificate."
  type        = list(string)
  default     = ["key_encipherment", "digital_signature", "server_auth"]
}

variable "self_signed_subject" {
  description = "Additional subject attributes for a self-signed certificate. common_name is taken from domain_name."
  type = object({
    organization        = optional(string)
    organizational_unit = optional(string)
    country             = optional(string)
    locality            = optional(string)
    province            = optional(string)
    street_address      = optional(list(string))
    postal_code         = optional(string)
  })
  default = {}
}
