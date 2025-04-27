

# Lambda Terraform Module

## What This Module Does

- Creates a fully tagged **AWS Lambda function**.
- Automatically **generates the Lambda function name** based on project and owner.
- **Applies standard tags** (Project, Owner, Lifecycle, CreatedDate, Managed_by, Terraform=true).
- Supports passing **additional user-defined tags**.
- Minimal required inputs for quick deployment.
- Attaches an **existing IAM Role** to the Lambda.

---

## How to Use

```hcl
module "lambda_function" {
  source = "../modules/lambda"

  project               = "ticketing-triage"
  owner                 = "ayush"
  function_runtime      = "nodejs18.x"
  function_handler      = "index.handler"
  function_source_path  = "lambda.zip"
  lambda_role_arn       = "arn:aws:iam::123456789012:role/lambda-execution-role"

  tags = {
    Team    = "DevOps"
    Purpose = "Event handler"
  }
}
```

- `project` and `owner` are used to auto-generate the function name.
- `function_source_path` points to your local `.zip` deployment package.
- `lambda_role_arn` is the IAM role the function will assume.
- Tags are automatically merged with reserved internal tags.

---

## Inputs

| Name | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `project` | `string` | — | Project name for naming and tagging |
| `owner` | `string` | `"ayush"` | Owner for naming and tagging |
| `resource_lifecycle` | `string` | `"temporary"` | Lifecycle tag (`temporary` or `longterm`) |
| `function_runtime` | `string` | — | Runtime for the Lambda function (e.g., `nodejs18.x`, `python3.11`) |
| `function_handler` | `string` | — | Lambda function entry point (e.g., `index.handler`) |
| `function_source_path` | `string` | — | Path to the zipped Lambda deployment package |
| `lambda_role_arn` | `string` | — | IAM Role ARN that the Lambda assumes |
| `tags` | `map(string)` | `{}` | Additional custom tags (cannot override reserved tags) |

---

## Outputs

| Name | Description |
|:-----|:------------|
| `function_name` | The generated name of the Lambda function |
| `function_arn` | The ARN of the Lambda function |

---

## Notes

- **IAM Role** is required and must be passed in via `lambda_role_arn`.
- **Tags are automatically merged** — reserved tags cannot be overridden.
- **Function names** follow the format:  
  `<project>-<owner>-lambda`

Example: `ticketing-triage-ayush-lambda`

- The deployment package (`lambda.zip`) must be available locally during `terraform apply`, or you can modify the module to use S3 deployment if needed.

---

#  In Short

> **This module creates a clean, auto-tagged AWS Lambda function with minimal inputs, matching production infrastructure standards.**

---

#  Next Step

- To trigger this Lambda function via an HTTP endpoint, you can combine it with an **API Gateway module**.
- To automate deployment packages to S3, you can add an **S3 upload helper**.


