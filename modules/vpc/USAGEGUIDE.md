

# VPC Terraform Module — Usage Guide

This Terraform module allows you to create flexible and customizable VPCs on AWS. You can configure it to create different kinds of VPCs, such as public-only, private-only, or mixed (public + private), with options for subnets, NAT gateways, and more.


## Input Variables Overview

| Variable                 | Type         | Description                                             | Default                       |
| ------------------------ | ------------ | ------------------------------------------------------- | ----------------------------- |
| `vpc_cidr`               | string       | The CIDR block for the VPC.                             | `"10.0.0.0/16"`               |
| `enable_public_subnets`  | bool         | Whether to create public subnets with Internet Gateway. | `true`                        |
| `enable_private_subnets` | bool         | Whether to create private subnets with NAT Gateway.     | `true`                        |
| `public_subnet_cidrs`    | list(string) | CIDRs for public subnets (one per AZ).                  | `[]`                          |
| `private_subnet_cidrs`   | list(string) | CIDRs for private subnets (one per AZ).                 | `[]`                          |
| `availability_zones`     | list(string) | List of AZs to deploy subnets in.                       | `["us-east-1a","us-east-1b"]` |
| `create_nat_gateway`     | bool         | Create NAT Gateways for private subnets?                | `true`                        |
| `enable_dns_support`     | bool         | Enable DNS support in the VPC.                          | `true`                        |
| `enable_dns_hostnames`   | bool         | Enable DNS hostnames in the VPC.                        | `true`                        |
| `tags`                   | map(string)  | Tags to apply to all resources.                         | `{}`                          |


## Example 1: Default VPC with public + private subnets and NAT Gateways

```hcl
module "vpc" {
  source                = "./modules/vpc"
  vpc_cidr              = "10.1.0.0/16"
  enable_public_subnets = true
  enable_private_subnets= true
  public_subnet_cidrs   = ["10.1.1.0/24", "10.1.2.0/24"]
  private_subnet_cidrs  = ["10.1.3.0/24", "10.1.4.0/24"]
  availability_zones    = ["us-east-1a", "us-east-1b"]
  create_nat_gateway    = true
  tags = {
    Project = "MyApp"
    Env     = "prod"
  }
}
```



## Example 2: Public-only VPC (no private subnets, no NAT)

```hcl
module "vpc" {
  source                = "./modules/vpc"
  vpc_cidr              = "10.2.0.0/16"
  enable_public_subnets = true
  enable_private_subnets= false
  public_subnet_cidrs   = ["10.2.1.0/24", "10.2.2.0/24"]
  availability_zones    = ["us-east-1a", "us-east-1b"]
  create_nat_gateway    = false
  tags = {
    Project = "MyPublicApp"
    Env     = "dev"
  }
}
```



## Example 3: Private-only VPC (no public subnets, all private)

```hcl
module "vpc" {
  source                = "./modules/vpc"
  vpc_cidr              = "10.3.0.0/16"
  enable_public_subnets = false
  enable_private_subnets= true
  private_subnet_cidrs  = ["10.3.1.0/24", "10.3.2.0/24"]
  availability_zones    = ["us-east-1a", "us-east-1b"]
  create_nat_gateway    = true
  tags = {
    Project = "MyPrivateApp"
    Env     = "staging"
  }
}
```



## Notes

* Make sure the CIDR blocks you specify for subnets do **not overlap** and fit inside the main VPC CIDR.
* When `enable_private_subnets` is `true` and `create_nat_gateway` is also `true`, NAT Gateways are created in public subnets for private subnet internet access.
* Customize tags as needed to help with resource identification and cost allocation.
* You can add more variables as needed to support additional VPC features (e.g., flow logs, additional route tables).

