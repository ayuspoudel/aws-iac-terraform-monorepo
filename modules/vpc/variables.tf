variable "project_name" {
  description = "Project name for tagging and naming"
  type        = string
}

variable "creation_date" {
  description = "Creation date for tagging"
  type        = string
  default     = formatdate("YYYY-MM-DD", timestamp())
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "availability_zones" {
  description = "List of AZs where subnets will be created"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "List of CIDRs for public subnets (one per AZ)"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of CIDRs for private subnets (one per AZ)"
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Whether to create NAT gateways"
  type        = bool
  default     = true
}

variable "nat_gateway_per_az" {
  description = "Create one NAT gateway per AZ if true; otherwise only one NAT gateway"
  type        = bool
  default     = true
}

variable "enable_vpn_gateway" {
  description = "Whether to create a VPN gateway"
  type        = bool
  default     = false
}

variable "vpn_customer_gateway_ips" {
  description = "List of customer gateway IPs (for VPN tunnels)"
  type        = list(string)
  default     = []
}

variable "enable_transit_gateway" {
  description = "Whether to attach this VPC to a Transit Gateway"
  type        = bool
  default     = false
}

variable "transit_gateway_id" {
  description = "Transit Gateway ID to attach this VPC to"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "extra_tags" {
  description = "Extra tags to merge into default tags"
  type        = map(string)
  default     = {}
}
