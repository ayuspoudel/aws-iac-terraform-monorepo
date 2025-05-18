variable "project_name" {
  description = "Project name for tagging and naming"
  type        = string
  validation {
    condition     = length(var.project_name) > 0
    error_message = "Project name must not be empty."
  }
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "VPC CIDR must be a valid CIDR block."
  }
}

variable "availability_zones" {
  description = "List of AZs where subnets will be created"
  type        = list(string)
  validation {
    condition     = length(var.availability_zones) > 0
    error_message = "At least one Availability Zone is required."
  }
}

variable "public_subnet_cidrs" {
  description = "List of CIDRs for public subnets (one per AZ)"
  type        = list(string)
  validation {
    condition     = length(var.public_subnet_cidrs) > 0 && length(var.public_subnet_cidrs) == length(var.availability_zones)
    error_message = "Public subnet CIDRs must match the number of Availability Zones and cannot be empty."
  }
}

variable "private_subnet_cidrs" {
  description = "List of CIDRs for private subnets (one per AZ)"
  type        = list(string)
  validation {
    condition     = length(var.private_subnet_cidrs) > 0 && length(var.private_subnet_cidrs) == length(var.availability_zones)
    error_message = "Private subnet CIDRs must match the number of Availability Zones and cannot be empty."
  }
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

  validation {
    condition     = var.enable_vpn_gateway ? length(var.vpn_customer_gateway_ips) > 0 : true
    error_message = "You must provide at least one Customer Gateway IP if VPN Gateway is enabled."
  }
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
  validation {
    condition     = var.enable_transit_gateway ? length(var.transit_gateway_id) > 0 : true
    error_message = "Transit Gateway ID is required if enable_transit_gateway is true."
  }
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

variable "create_transit_gateway" {
  description = "Whether to create transit gateway or not"
  type        = bool
  default     = false
}