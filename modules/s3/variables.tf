variable "project" {
  description = "Project name for naming and tagging."
  type        = string
}

variable "owner" {
  description = "Owner of the infrastructure."
  type        = string
  default     = "ayush"
}

variable "lifecycle" {
  description = "Lifecycle tag (temporary or longterm)"
  type        = string
  default     = "temporary"
}

variable "force_destroy" {
  description = "Allow force destroy of the S3 bucket."
  type        = bool
  default     = false
}

variable "prevent_destroy" {
  description = "Prevent destruction of S3 bucket."
  type        = bool
  default     = false
}
