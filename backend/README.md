# Terraform Backend Setup

This folder provisions the necessary AWS infrastructure to support remote Terraform state management. It is intended to be applied **once per environment** (e.g., dev, prod) before running the actual Terraform modules that use this backend.

---

## What This Module Creates

- **S3 Bucket**: Stores Terraform state files securely and durably.
- **DynamoDB Table**: Used to lock state and avoid race conditions in collaborative environments.

---

##  Folder Structure

```
terraform/
└── backend/
    ├── main.tf             # S3 + DynamoDB resources
    ├── variables.tf        # Input configuration
    └── README.md           # This file
```

---

##  Input Variables

| Variable           | Description                         | Default                    |
|--------------------|-------------------------------------|----------------------------|
| `region`           | AWS region for backend resources     | `us-east-1`                |
| `bucket_name`      | Name of the S3 bucket to create      | `my-terraform-state-bucket`|
| `lock_table_name`  | Name of the DynamoDB lock table      | `terraform-locks`          |

---

##  Usage

### Step 1: Navigate to the backend folder

```bash
cd terraform/backend
```

### Step 2: Initialize and apply

```bash
terraform init
terraform apply
```
This creates the remote backend components.

---

## Note

- **Do not destroy** this stack unless you're migrating backends or decommissioning the environment.
- This folder should be run independently **before** initializing any Terraform config that uses this backend.

---

## Example: Backend Configuration in Root Module

In your `backend.tf` (outside this folder):

```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "iam/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
```

Then:

```bash
cd terraform
terraform init
```

Terraform will detect the backend config and ask to migrate your state.

---

## Best Practices

- Enable versioning on the S3 bucket (already handled here).
- Never commit state files to Git.
- Use separate state files per component/module/environment (via unique `key` values).

---

## Related

- AWS S3 as Backend: https://developer.hashicorp.com/terraform/language/settings/backends/s3
- DynamoDB Locking: https://developer.hashicorp.com/terraform/language/settings/backends/s3#dynamodb-table

---

## 👤 Maintainer
This backend infrastructure is typically maintained by the DevOps/SRE team.

