variable "enabled" {
  description = "Whether to enable this module and create any resources"
  type        = bool
  default     = true
}

variable "create_security_group" {
  description = "Whether to create a new security group or use an existing one"
  type        = bool
  default     = true
}

variable "name" {
  description = "Name of the security group"
  type        = string
}

variable "description" {
  description = "Description for the security group"
  type        = string
  default     = "Managed by Terraform"
}

variable "vpc_id" {
  description = "VPC ID where the security group will be created"
  type        = string
}

variable "revoke_rules_on_delete" {
  description = "Revoke security group rules on delete"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to the security group"
  type        = map(string)
  default     = {}
}

variable "default_cidr_blocks" {
  description = "Default CIDR blocks to use for rules (fallback)"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "ingress_rule_keys" {
  type        = list(string)
  default     = []
  description = "List of keys from predefined_rules to automatically expand into ingress rules."
}

variable "egress_rule_keys" {
  type        = list(string)
  default     = []
  description = "List of keys from predefined_rules to automatically expand into ingress rules."
}