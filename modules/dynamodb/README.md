#  DynamoDB Terraform Module

## What This Module Does

- Creates a **DynamoDB table** for Terraform state locking.
- **Auto-generates table name** based on project and owner.
- **Applies standard tags** automatically (Project, Owner, Terraform, Lifecycle, CreatedDate).
- Sets **prevent_destroy** to protect against accidental deletion.

---

## How to Use

```hcl
module "dynamodb_backend" {
  source = "../modules/dynamodb"

  project = "ticketing-triage"
  owner   = "ayush.poudel"

  # Optional
  lifecycle = "temporary"
}
```

- `project` and `owner` are required.
- `lifecycle` is optional.

The table name will be auto-created like:  
`ticketing-triage-ayush.poudel-locks`

---

## Inputs

| Name | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `project` | `string` | — | Project name |
| `owner` | `string` | — | Owner name |
| `lifecycle` | `string` | `"temporary"` | Lifecycle tag (temporary or longterm) |

---

## Outputs

| Name | Description |
|:-----|:------------|
| `table_name` | DynamoDB table name |
| `table_id` | DynamoDB table ID (ARN) |

---

# Quick Example

```hcl
output "backend_lock_table" {
  value = module.dynamodb_backend.table_name
}
```

---

# Notes

- Table is **PAY_PER_REQUEST** billing mode (no provisioning needed).
- Tags are **applied automatically**; no need to pass them.
- Table **cannot be destroyed accidentally** (`prevent_destroy = true`).

---

# In Short:

> **This module creates a secure DynamoDB locking table for Terraform backend with minimal inputs.**
