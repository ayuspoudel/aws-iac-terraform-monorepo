locals {
  creation_date = formatdate("YYYY-MM-DD", timestamp())

  # Naming
  vpc_name = "${var.project_name}-vpc-${replace(var.vpc_cidr, "/", "-")}"
  igw_name = "${var.project_name}-igw-${replace(var.vpc_cidr, "/", "-")}"

  public_subnet_names = [
    for i, az in var.availability_zones :
    "${var.project_name}-public-subnet-${az}-${replace(var.public_subnet_cidrs[i], "/", "-")}"
  ]

  private_subnet_names = [
    for i, az in var.availability_zones :
    "${var.project_name}-private-subnet-${az}-${replace(var.private_subnet_cidrs[i], "/", "-")}"
  ]

  nat_gateway_names = [
    for az in var.availability_zones :
    "${var.project_name}-nat-gateway-${az}"
  ]

  vpn_gateway_name               = "${var.project_name}-vpn-gateway-${replace(var.vpc_cidr, "/", "-")}"
  transit_gateway_attachment_name = "${var.project_name}-tgw-attachment-${replace(var.vpc_cidr, "/", "-")}"

  # Tagging
  common_tags = {
    "Project-Name"  = var.project_name
    "Creation-Date" = local.creation_date
    "Managed-By"    = "Terraform"
  }

  merged_tags = merge(
    local.common_tags,
    var.extra_tags,
    var.tags
  )
}
