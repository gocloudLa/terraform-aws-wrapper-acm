output "acm_certificate_arn" {
  description = "ARN of the certificate."
  value       = try(aws_acm_certificate_validation.this[0].certificate_arn, aws_acm_certificate.this[0].arn, aws_acm_certificate.imported[0].arn, "")
}

output "acm_certificate_domain_validation_options" {
  description = "Attributes used to complete DNS validation. Set only for Amazon-issued certificates validated by DNS."
  value       = flatten(aws_acm_certificate.this[*].domain_validation_options)
}

output "acm_certificate_status" {
  description = "Status of the certificate."
  value       = try(aws_acm_certificate.this[0].status, aws_acm_certificate.imported[0].status, "")
}

output "acm_certificate_validation_emails" {
  description = "Addresses that received a validation email. Set only when EMAIL validation is used."
  value       = flatten(aws_acm_certificate.this[*].validation_emails)
}

output "validation_route53_record_fqdns" {
  description = "FQDNs of the Route53 validation records."
  value       = aws_route53_record.validation[*].fqdn
}

output "distinct_domain_names" {
  description = "Distinct domain names used for validation."
  value       = local.distinct_domain_names
}

output "validation_domains" {
  description = "Distinct domain validation options, with wildcard prefixes removed."
  value       = local.validation_domains
}
