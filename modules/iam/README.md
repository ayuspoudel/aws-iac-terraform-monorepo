# Terraform IAM User Module

This Terraform module creates an AWS IAM user with the following features:

- Dynamically generated IAM user name and path based on environment, team, and owner.
- Programmatic access key generation (access key ID + secret access key).
- Support for multiple inline policies via external JSON files.
- Automatically stores access credentials securely in AWS Secrets Manager.
- Merges required and user-defined tags.

---

## Module Structure

```bash
modules/
└── iam/
    ├── datas.tf                    # Loads policy files
    ├── iam_users.tf                # Defines IAM user, access key, and policies
    ├── locals.tf                   # Composes IAM naming and tags
    ├── policies/                   # Folder for policy JSON files
    │   └── AdministratorAccess.json
    ├── variables.tf                # Input variables
    └── outputs.tf (optional)       # Outputs like secret ARN, IAM name
```

---

## Features

- IAM user name and path are auto-generated from `environment`, `team`, and `owner`
- Securely stores IAM credentials in Secrets Manager
- Reads multiple policy files from disk and attaches them as inline IAM user policies
- Tags IAM user and secret with required + optional tags

---

## How to Use This Module

### Example Usage

```hcl
module "iam_user_admin" {
  source      = "./modules/iam"

  environment = "prod"
  team        = "platform"
  owner       = "ayush"

  tags = {
    Terraform  = "true"
    CostCenter = "CC-123"
  }

  policy_files = {
    AdministratorAccess = "${path.module}/modules/iam/policies/AdministratorAccess.json"
  }
}
```

---

## Input Variables

| Variable       | Type          | Description                                             | Required |
|----------------|---------------|---------------------------------------------------------|----------|
| `environment`  | `string`      | Environment name (e.g., `dev`, `prod`)                 | Yes      |
| `team`         | `string`      | Team responsible for this user                         | Yes      |
| `owner`        | `string`      | Individual responsible for this user                   | Yes      |
| `tags`         | `map(string)`| Additional tags (required tags are auto-added)         | Optional |
| `policy_files` | `map(string)`| Map of policy names to local JSON file paths           | Yes      |

---

## Outputs

| Output Name           | Description                                    |
|------------------------|------------------------------------------------|
| `iam_user_secret_arn`  | ARN of the Secrets Manager secret             |
| `iam_user_name`        | Name of the created IAM user                  |

---

## Secrets Manager

The following secret is created:

- **Name**: `iam/<iam_user_name>/credentials`
- **Value**:

```json
{
  "access_key_id": "AKIA...",
  "secret_access_key": "abc123...",
  "iam_user": "prod-platform-ayush"
}
```

---

## Notes

- Inline policies are loaded from JSON files. Keep those policies in `modules/iam/policies/` or pass your own full path.
- The IAM access keys are not exposed as output (they're stored securely in Secrets Manager).
- You can optionally use a custom KMS key for encrypting the secret.

---

## Future Enhancements

- [ ] Optional support for managed policies instead of inline
- [ ] Support for multiple users via `for_each`
- [ ] MFA/console login support
- [ ] Automatic key rotation

---

## Best Practices Followed

- Least privilege with flexible inline policies
- Secret stored securely and not printed to terminal
- Structured tagging for automation and cost allocation
- Consistent IAM naming convention for easier auditing