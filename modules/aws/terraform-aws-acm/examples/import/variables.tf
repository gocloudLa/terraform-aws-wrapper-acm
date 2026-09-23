variable "certificate_body" {
  description = "PEM-encoded certificate body to import."
  type        = string
  sensitive   = true
}

variable "private_key" {
  description = "PEM-encoded private key to import."
  type        = string
  sensitive   = true
}

variable "certificate_chain" {
  description = "PEM-encoded certificate chain to import."
  type        = string
  default     = null
  sensitive   = true
}
