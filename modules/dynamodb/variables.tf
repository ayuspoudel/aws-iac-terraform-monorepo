
variable "project" {
  description = "Project name for naming and tagging."
  type        = string
}

variable "owner" {
  description = "Owner of the infrastructure."
  type        = string
}

variable "resource_lifecycle" {
  description = "Lifecycle tag (temporary or longterm)"
  type        = string
  default     = "temporary"
}
