# S3 Terraform Module

## What This Module Does

- Creates an **S3 bucket** for storing Terraform state.
- **Encrypts** the bucket using **AES-256** encryption.
- **Enables versioning** to protect state history.
- **Auto-generates bucket name** based on project and owner.
- **Applies standard tags** automatically (Project, Owner, Terraform, Lifecycle, CreatedDate).

---

## How to Use

```hcl
module "s3_backend" {
  source = "../modules/s3"

  project = "ticketing-triage"
  owner   = "ayush.poudel"

  # Optional
  lifecycle       = "temporary"
  force_destroy   = true
  prevent_destroy = false
}
```

- `project` and `owner` are required.
- `lifecycle`, `force_destroy`, and `prevent_destroy` are optional.
- The bucket name will be auto-created like:  
  `ticketing-triage-ayush.poudel-state`.

---

## Inputs

| Name | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `project` | `string` | — | Project name |
| `owner` | `string` | — | Owner name |
| `lifecycle` | `string` | `"temporary"` | Lifecycle tag (temporary or longterm) |
| `force_destroy` | `bool` | `false` | Force destroy bucket if needed |
| `prevent_destroy` | `bool` | `true` | Prevent accidental deletion |

---

## Outputs

| Name | Description |
|:-----|:------------|
| `bucket_id` | S3 bucket ID |
| `bucket_name` | S3 bucket name |

---

# Quick Example

```hcl
output "backend_bucket" {
  value = module.s3_backend.bucket_name
}
```

---

# Notes

- Versioning and encryption are **enabled by default**.
- Bucket names are **auto-generated** inside the module.
- Tags are **applied automatically**; no need to pass them.

---

#  In Short:

> **This module creates a secure, tagged, versioned S3 bucket for Terraform backend with minimal inputs.**
