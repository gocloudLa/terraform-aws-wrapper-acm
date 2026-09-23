# terraform-aws-acm

Local ACM module used by the wrapper. It issues an Amazon certificate, imports a PEM certificate supplied by the caller, or generates a self-signed certificate and imports it into ACM.

## Amazon-issued

```hcl
module "acm" {
  source = "./modules/aws/terraform-aws-acm"

  domain_name               = "example.com"
  subject_alternative_names = ["*.example.com"]
  validation_method         = "DNS"
  zone_id                   = "Z1234567890EXAMPLE"
}
```

`certificate_source` defaults to `amazon`. DNS validation records are created in Route53 when `create_route53_records` and `validate_certificate` are true.

## Import

```hcl
module "acm" {
  source = "./modules/aws/terraform-aws-acm"

  certificate_source = "import"
  certificate_body   = file("${path.module}/certs/imported.crt")
  private_key        = file("${path.module}/certs/imported.key")
  certificate_chain  = file("${path.module}/certs/chain.crt")
}
```

`private_key` and `certificate_body` are required. `certificate_chain` is optional. ACM reads the domain names from the certificate, so Route53 validation resources are not created.

## Self-signed

```hcl
module "acm" {
  source = "./modules/aws/terraform-aws-acm"

  certificate_source        = "self_signed"
  domain_name               = "internal.example.com"
  subject_alternative_names = ["*.internal.example.com"]
}
```

The module generates a private key and certificate with the `tls` provider, then imports that PEM into ACM. `domain_name` is the common name. `key_algorithm` accepts `RSA_2048` (default), `RSA_4096`, `EC_prime256v1`, and `EC_secp384r1`.

Each call generates its own key pair. To place the same certificate in more than one region, use `import` and pass the same PEM.

## Notes

- `private_key`, `certificate_body`, and `certificate_chain` are stored in Terraform state. A self-signed private key is stored there as well.
- ACM does not renew imported or self-signed certificates. Terraform renews a self-signed certificate `self_signed_early_renewal_hours` before it expires (default 720) and updates the ACM import.
- Self-signed certificates are not publicly trusted.
