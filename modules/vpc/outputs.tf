output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.this.cidr_block
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = aws_subnet.private[*].id
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = var.enable_internet_gateway ? aws_internet_gateway.igw.id : null
}

output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs"
  value       = var.enable_nat_gateway ? aws_nat_gateway.this[*].id : []
}

output "vpn_gateway_id" {
  description = "ID of VPN Gateway if enabled"
  value       = var.enable_vpn_gateway ? aws_vpn_gateway.vpn_gateway.id : null
}

output "route_table_public_id" {
  description = "Public route table ID"
  value       = aws_route_table.public.id
}

output "route_table_private_id" {
  description = "Private route table ID"
  value       = aws_route_table.private.id
}

output "tags" {
  description = "Common tags applied to resources"
  value       = local.merged_tags
}
