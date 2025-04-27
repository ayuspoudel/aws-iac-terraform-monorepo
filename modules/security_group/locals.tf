locals {
  default_allowed_ip = [data.external.public_ip.result["public_ip"]]
}
