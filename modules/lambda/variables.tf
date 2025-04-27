variable "project" {
  description = "Project name for naming and tagging."
  type        = string
}

variable "owner" {
  description = "Owner of the infrastructure."
  type        = string
  default     = "ayush"
}

variable "resource_lifecycle" {
  description = "Lifecycle tag for the resource (temporary or longterm)"
  type        = string
  default     = "temporary"
}

variable "function_runtime" {
  description = "Lambda runtime environment."
  type        = string
}

variable "function_handler" {
  description = "Lambda handler function."
  type        = string
}

variable "function_source_path" {
  description = "Path to the zipped Lambda deployment package."
  type        = string
}

variable "tags" {
  type        = map(string)
  description = "Additional user-defined tags."
  default     = {}

  validation {
    condition = alltrue([
      !contains(keys(var.tags), "Lifecycle"),
      !contains(keys(var.tags), "Project"),
      !contains(keys(var.tags), "Owner"),
      !contains(keys(var.tags), "Terraform"),
      !contains(keys(var.tags), "CreatedDate"),
      !contains(keys(var.tags), "Managed_by")
    ])
    error_message = "You cannot override reserved tags: Lifecycle, Project, Owner, Terraform, CreatedDate, Managed_by"
  }
}

variable "lambda_role_arn" {
  description = "The ARN of the IAM Role for the Lambda function to assume."
  type        = string
}