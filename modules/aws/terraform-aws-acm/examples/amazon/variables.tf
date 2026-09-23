variable "domain_name" {
  description = "Primary domain name of the Amazon-issued certificate."
  type        = string
  default     = "example.com"
}

variable "zone_id" {
  description = "Route53 hosted zone ID used for DNS validation."
  type        = string
  default     = "Z1234567890EXAMPLE"
}
