# Terraform VPC Module README

### Overview

This Terraform module creates a fully featured AWS VPC with flexible, production-ready networking components. It supports multiple deployment patterns — from simple single-AZ VPCs to highly available multi-AZ architectures with hub-and-spoke connectivity and VPN integration.

### What This Module Provides

- VPC with configurable CIDR block
- Public and Private Subnets (one or multiple per AZ)
- Route Tables for public and private subnets
- Internet Gateway (IGW) for internet access in public subnets
- NAT Gateways for outbound internet from private subnets
- VPN Gateway and Customer Gateway support for on-prem connectivity
- Transit Gateway attachment support for hub/spoke architecture
- Dynamic tagging and naming for all resources (project, creation date, managed by Terraform, etc.)
- Support for multiple availability zones (AZs) for HA or single AZ deployment
- Hub-or-Spoke topology selection
- Optional: Enable or disable HA NAT Gateways (one per AZ or shared)
- Full control of subnet CIDRs for public/private subnets

### Types of VPC Architectures You Can Create
| Type           | Description                                                      | Use Case                               |
|----------------|------------------------------------------------------------------|--------------------------------------|
| Single AZ Simple| One AZ with public and private subnets, single NAT Gateway       | Small workloads, dev/test             |
| Multi-AZ HA    | Public/private subnets across multiple AZs, NAT Gateway per AZ, redundant routing | Production, high availability         |
| Hub VPC        | Central VPC with Transit Gateway attachment, acting as network hub| Shared services, cross-VPC connectivity|
| Spoke VPC      | VPC attached to Transit Gateway hub, with private/public subnets | Application workloads connecting via hub |
| VPN Enabled    | VPC with VPN Gateway and Customer Gateway IPs for secure on-prem connectivity | Hybrid cloud environments             |


### Key Features

- Flexible subnet configuration: Supply CIDRs per subnet per AZ
- Dynamic tagging & naming: Every resource is tagged with project-name, creation_date, managed_by, and merged user-defined tags
- Multi-AZ support: Automatically creates resources per AZ if multiple AZs provided
- Dynamic NAT Gateway provisioning: One NAT Gateway per AZ or a shared NAT Gateway based on input flags
- Hub & Spoke support: Attach to an existing Transit Gateway and define the VPC role
- VPN support: Optionally create VPN Gateway with customer IPs
- Safe defaults: DNS support and hostnames enabled in VPC

### Example Usage

```bash
module "vpc" {
  source = "path/to/this/module"

  project_name           = "myproject"
  vpc_cidr               = "10.0.0.0/16"
  availability_zones     = ["us-east-1a", "us-east-1b"]
  public_subnet_cidrs    = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs   = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway     = true
  nat_gateway_per_az     = true

  enable_vpn_gateway     = false
  enable_transit_gateway = false

  hub_or_spoke           = "spoke"

  tags = {
    Environment = "prod"
    Owner       = "team-network"
  }
}
```

# Dynamic Tagging & Naming

All resources are tagged with mandatory keys like:

```bash
project-name (from input)

creation_date (set at apply time)

managed_by = "terraform"
```
User can add/override tags via the tags input variable

Resource names follow the convention:

```bash
<project_name>-<resource_type>[-<az>]
e.g. myproject-public-subnet-us-east-1a
```

### Cautions & Recommendations

- Ensure subnet CIDRs do not overlap and fit inside the VPC CIDR
- When using multi-AZ, provide CIDRs and AZs of equal length
- If using nat_gateway_per_az = true, ensure private_subnet_cidrs and route tables are created per AZ
- VPN gateway creation requires specifying valid customer gateway IPs
- Transit Gateway support requires an existing TGW ID and appropriate permissions
- Deleting this module will delete all managed resources — backup important data
- Test in non-prod before deploying to production

### How to Use

- Configure your desired VPC topology by setting variables for CIDRs, AZs, NAT gateway options, VPN, and hub/spoke mode.
- Add custom tags as needed via tags variable.
- Call the module in your Terraform root module.
- Run terraform init and terraform apply.
- Use output values to integrate with other modules (e.g., subnet IDs, route table IDs).

#### Outputs

```bash
vpc_id — VPC resource ID

public_subnets — List of public subnet IDs

private_subnets — List of private subnet IDs

nat_gateway_ids — List of NAT Gateway IDs

vpn_gateway_id — VPN Gateway ID (if enabled)

route_table_ids — Map of route tables per subnet type
```
---

Use this module to quickly bootstrap versatile VPC architectures while keeping everything consistent and manageable with clear naming and tagging standards.