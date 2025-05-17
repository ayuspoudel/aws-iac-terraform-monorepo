

 

# Cloud Infrastructure as Code (IaC) Monorepo

[![Terraform](https://img.shields.io/badge/Terraform-v1.5-blue)](https://www.terraform.io/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Issues](https://img.shields.io/github/issues/yourusername/yourrepo.svg)](https://github.com/ayuspoudel/cloud-iac-monorepo/issues)

### Maintainers

Ayush Poudel – main maintainer and contributor
Community contributors — thank you for your support!

--- 
Welcome to the **Cloud IaC Monorepo** — a modular, reusable, and community-friendly Terraform codebase designed to help teams rapidly provision and manage AWS infrastructure for diverse projects.

 

## Purpose

This repository hosts a collection of **Terraform modules** and **environment configurations** used across multiple real-world projects. Each environment directory corresponds to a distinct project — the folder names match the project repository names on GitHub, making it easy to associate the infrastructure code with application codebases.

The goal is to provide a **clean, modular, and extensible foundation** that anyone can use, adapt, and contribute to. Whether you're building serverless applications, container platforms, or microservices architectures, this repo offers well-structured building blocks to get your infrastructure up and running quickly.

 

## Repo Structure

```
.
├── backend/                   # Common Terraform backend configs (S3, DynamoDB)
├── environments/              # Project-specific infrastructure code
│   ├── <project-name>/        # Each project environment (matches GitHub repo names)
│   │   ├── *.tf               # Environment-specific Terraform files
│   │   └── ...
├── modules/                   # Reusable Terraform modules
│   ├── vpc/                   # VPC module (networking)
│   ├── s3/                    # S3 bucket module
│   ├── dynamodb/              # DynamoDB table module
│   ├── ec2_instance/          # EC2 module
│   ├── eks/                   # EKS (Kubernetes) module
│   ├── iam/                   # IAM roles and policies module
│   ├── lambda/                # Lambda function module
│   └── security_group/        # Security groups module
└── README.md                  # This file
```

 

## Prerequisites

* [Terraform](https://www.terraform.io/downloads.html) version 1.4+ installed
* AWS CLI configured with appropriate IAM permissions
* AWS account access with rights to create networking, compute, and other resources

 

## Why This Repo?

* **Modularity:** Each module is designed to be standalone and composable so you can pick and choose what you need.
* **Project Alignment:** Environment folders are tightly coupled with actual project repos for easy traceability.
* **Community-Oriented:** Open to collaboration! If you find bugs, want new features, or improvements, please contribute.
* **Scalability:** Supports projects of varying sizes — from small apps to complex microservices with multiple AWS services.
* **Best Practices:** Uses Terraform best practices for backend configuration, state management, and code organization.

 

## Getting Started

1. Explore reusable modules located in the `/modules` directory to understand available resources.
2. Choose or create your environment folder inside `/environments/<project-name>/` matching your project.
3. Customize input variables in your environment’s `.tf` files to suit your infrastructure needs.
4. Initialize Terraform and deploy your infrastructure:

```bash
cd environments/<project-name>/
terraform init
terraform apply
```

 

## Contributing

Contributions are very welcome! Whether it’s:

* New modules or enhancements to existing ones
* Bug fixes or documentation improvements
* Suggestions for better patterns or tooling

Please open issues or submit pull requests. Follow the existing style and add documentation for your changes.

 

## Suggestions & Roadmap

Open to ideas on:

* Adding more modules (RDS, CloudFront, SNS, SQS, etc.)
* Improved CI/CD integration for module testing
* Examples for multi-account, multi-region setups
* Automated security auditing hooks

Feel free to open discussions or reach out!

 

Thank you for checking out this repo. I hope it helps you build your cloud infrastructure efficiently and reliably!

**Happy Terraforming!**

 

If you want, I can also help you write CONTRIBUTING.md or example environment configs next!
