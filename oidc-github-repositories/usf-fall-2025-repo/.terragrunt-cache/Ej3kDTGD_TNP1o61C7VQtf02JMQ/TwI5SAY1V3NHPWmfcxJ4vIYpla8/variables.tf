variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region to deploy IAM role and OIDC provider"
}

variable "repo" {
  description = "GitHub repository in the form owner/repo (e.g. ayuspoudel/usf-fall-2025-repo)"
  type        = string
}

variable "role_name" {
  description = "IAM role name to create for this repo"
  type        = string
}

variable "policies" {
  description = "List of IAM policy ARNs to attach to the role"
  type        = list(string)
  default     = []
}
