module "acm" {
  source = "../../"

  certificate_source = "import"
  certificate_body   = var.certificate_body
  private_key        = var.private_key
  certificate_chain  = var.certificate_chain
}
