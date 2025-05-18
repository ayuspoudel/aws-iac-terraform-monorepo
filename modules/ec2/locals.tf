# locals.tf

locals {
  default_tags = merge({
    Terraform   = "true",
    Environment = "managed",
    Name        = var.name
  }, var.tags)

  instance_name = "${var.name}-${var.launch_type}"
}