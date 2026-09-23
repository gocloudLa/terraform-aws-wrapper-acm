output "acm_certificate_arns" {
  description = "Map of ACM certificate ARNs keyed by acm_parameters."
  value       = { for k, m in module.acm : k => m.acm_certificate_arn }
}

output "acm_certificate_statuses" {
  description = "Map of ACM certificate statuses keyed by acm_parameters."
  value       = { for k, m in module.acm : k => m.acm_certificate_status }
}

output "acm_secondary_certificate_arns" {
  description = "Map of us-east-1 ACM certificate ARNs keyed by acm_parameters."
  value       = { for k, m in module.acm_secondary : k => m.acm_certificate_arn }
}

output "acm_secondary_certificate_statuses" {
  description = "Map of us-east-1 ACM certificate statuses keyed by acm_parameters."
  value       = { for k, m in module.acm_secondary : k => m.acm_certificate_status }
}
