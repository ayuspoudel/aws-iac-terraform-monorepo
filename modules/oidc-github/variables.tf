variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "repo_name" {
  description = "GitHub repo (owner/repo)"
  type        = string
}

variable "policy_arns" {
  description = "List of IAM policies to attach"
  type        = list(string)
}
