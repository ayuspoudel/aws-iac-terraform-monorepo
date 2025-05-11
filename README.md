
# Cloud IaC Monorepo (Terraform)
---

A modular, environment-driven Infrastructure-as-Code (IaC) monorepo built with Terraform. This repository supports reusable modules, dynamic resource naming, and isolated environments for real-world DevOps automation and cloud-native architectures.

---

#### Repository Structure

```

.
├── backend/                         # Remote state configuration
├── environments/                   # Per-project infra definitions (production, dev, etc.)
│   ├── end-end-devops-microservices/
│   └── serverless-github-jira-automation/
├── modules/                        # Reusable Terraform modules
│   ├── dynamodb/
│   ├── ec2\_instance/
│   ├── eks/
│   ├── iam/
│   ├── lambda/
│   ├── s3/
│   └── security\_group/
└── .github/                        # CI/CD workflows for apply/destroy (GitHub Actions)

````

## Environments

Each folder inside `environments/` represents a deployable application or project. These define infrastructure using reusable modules and are configured with their own state backend and variable overrides.

### Available Environments

- `end-end-devops-microservices`: A fully containerized infrastructure for DevOps microservices, including EKS, IAM, and S3.
- `serverless-github-jira-automation`: A serverless, event-driven workflow automation stack powered by Lambda and ECR.

You can deploy each independently by navigating to its directory and running:

```bash
terraform init -backend-config=../../backend/main.tf
terraform apply
````

---

#### Modules

Modules are defined under the `modules/` directory and are used across environments. Each module encapsulates a specific AWS resource or logical group of resources.

##### Example Usage

```hcl
module "s3_logs" {
  source      = "../../modules/s3"
  bucket_name = "${var.project}-${var.env}-logs"
  versioning  = true
}
```

##### Modules Available

| Module           | Description                         |
| ---------------- | ----------------------------------- |
| `s3`             | Secure S3 bucket with versioning    |
| `iam`            | IAM roles, policies, and users      |
| `lambda`         | Lambda function and IAM execution   |
| `dynamodb`       | DynamoDB table configuration        |
| `eks`            | Kubernetes cluster provisioning     |
| `ec2_instance`   | EC2 instance with SG and tags       |
| `security_group` | Reusable security group definitions |

Each module includes:

* `variables.tf`: Input variables
* `outputs.tf`: Exported values
* `README.md`: Documentation and usage

##### Naming Conventions

All resources follow a consistent naming strategy:

```
<project>-<env>-<resource-type>
```

For example:

* `jira-dev-lambda-slack`
* `microservices-prod-eks-cluster`
* `automation-stg-s3-reports`

This ensures:

* Clear ownership and environment separation
* Safe redeployability across stages
* Easy resource discovery in AWS Console


#### Automation

GitHub Actions are configured to automatically:

* Lint and validate Terraform configs
* Apply and destroy environments via PRs or workflow dispatch
* Securely handle backend state configuration
* Enforce formatting and best practices

You’ll find those in `.github/workflows/`, split per environment.



#### Getting Started

```bash
git clone https://github.com/your-username/cloud-iac-monorepo.git
cd environments/serverless-github-jira-automation

terraform init -backend-config=../../backend/main.tf
terraform apply
```

---

#### Contributing

1. Fork the repo
2. Create a branch
3. Add/update module or environment
4. Run `terraform fmt && terraform validate`
5. Submit a pull request

---

#### License

MIT © 2025 Ayush Poudel

