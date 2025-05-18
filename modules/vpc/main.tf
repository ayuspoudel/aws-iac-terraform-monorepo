# VPC
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(local.merged_tags, { Name = local.vpc_name })
}

# Internet Gateway
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(local.merged_tags, { Name = local.igw_name })
}

# Public Subnets
resource "aws_subnet" "public" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(local.merged_tags, {
    Name = local.public_subnet_names[count.index]
  })
}

# Private Subnets
resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = merge(local.merged_tags, {
    Name = local.private_subnet_names[count.index]
  })
}

# NAT Gateways
resource "aws_nat_gateway" "this" {
  count         = var.enable_nat_gateway ? (var.nat_gateway_per_az ? length(var.availability_zones) : 1) : 0
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = var.nat_gateway_per_az ? aws_subnet.public[count.index].id : aws_subnet.public[0].id

  tags = merge(local.merged_tags, {
    Name = var.nat_gateway_per_az ? format("%s-nat-gateway-%d", var.project_name, count.index) : "${var.project_name}-nat-gateway"
  })
}

# Elastic IPs for NAT Gateways
# If enable_nat_gateway is true it checks if nat_gateway_per_az is true, if yes creates as many as given availibility zone
resource "aws_eip" "nat" {
  count = var.enable_nat_gateway ? (var.nat_gateway_per_az ? length(var.availability_zones) : 1) : 0

  domain = "vpc"   # fixed deprecated 'vpc' argument

  tags = merge(local.merged_tags, {
    Name = var.nat_gateway_per_az ? format("%s-nat-gateway-%d-eip", var.project_name, count.index) : format("%s-nat-gateway-eip", var.project_name)
  })
}

# Public Route Table and Associations
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = merge(local.merged_tags, { Name = "${var.project_name}-public-rt" })
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public_subnet_association" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Private Route Tables, NAT routes, and Associations
resource "aws_route_table" "private" {
  count  = length(var.availability_zones)
  vpc_id = aws_vpc.this.id

  tags = merge(local.merged_tags, {
    Name = "${var.project_name}-private-rt-${var.availability_zones[count.index]}"
  })
}

resource "aws_route" "private_nat_gateway" {
  count                  = var.enable_nat_gateway ? length(var.availability_zones) : 0
  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[var.nat_gateway_per_az ? count.index : 0].id
}

resource "aws_route_table_association" "private_subnet_association" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

# VPN Gateway (optional)
resource "aws_vpn_gateway" "this" {
  count  = var.enable_vpn_gateway ? 1 : 0
  vpc_id = aws_vpc.this.id

  tags = merge(local.merged_tags, {
    Name = local.vpn_gateway_name
  })
}

# Transit Gateway (optional)
resource "aws_ec2_transit_gateway" "this" {
  count       = var.create_transit_gateway ? 1 : 0
  description = "${var.project_name} Transit Gateway"
  tags        = merge(local.merged_tags, { Name = "${var.project_name}-tgw" })
}

# Transit Gateway Attachment (optional)
resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  count              = var.enable_transit_gateway ? 1 : 0
  transit_gateway_id = var.create_transit_gateway ? aws_ec2_transit_gateway.this[0].id : var.transit_gateway_id
  vpc_id             = aws_vpc.this.id
  subnet_ids         = aws_subnet.private[*].id

  tags = merge(local.merged_tags, {
    Name = local.transit_gateway_attachment_name
  })
}


