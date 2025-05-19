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
  description = "VPC ID where the security group will be created. If not provided, the default VPC will be used."
  type        = string
  default     = null
}

# Failover for VPC ID = null
data "aws_vpc" "default" {
  default = true
  count   = var.vpc_id == null ? 1 : 0
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

variable "ingress_rule_keys" {
  description = "List of predefined ingress rule keys (e.g., ['http', 'ssh'])"
  type        = list(string)
  default     = []
}

variable "egress_rule_keys" {
  description = "List of predefined egress rule keys (e.g., ['all-allow'])"
  type        = list(string)
  default     = []
}
variable "default_cidr_blocks" {
  description = "Default CIDR blocks to use for rules (fallback)"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "ingress_rules" {
  description = <<EOT
List of ingress rules to create.
Each rule can:
- Use `rule_key` to reference a predefined rule
- Or directly define `from_port`, `to_port`, and `protocol`
EOT

  type = list(object({
    rule_key         = optional(string)
    from_port        = optional(number)
    to_port          = optional(number)
    protocol         = optional(string)
    description      = optional(string)
    cidr_blocks      = optional(list(string))
    ipv6_cidr_blocks = optional(list(string))
    prefix_list_ids  = optional(list(string))
    self             = optional(bool)
  }))

  default = []

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      can(r.rule_key) || (can(r.from_port) && can(r.to_port) && can(r.protocol))
    ])
    error_message = "Each ingress rule must include either a rule_key or from_port/to_port/protocol."
  }
}

variable "egress_rules" {
  description = <<EOT
List of egress rules to create.
Each rule can:
- Use `rule_key` to reference a predefined rule
- Or directly define `from_port`, `to_port`, and `protocol`
EOT

  type = list(object({
    rule_key         = optional(string)
    from_port        = optional(number)
    to_port          = optional(number)
    protocol         = optional(string)
    description      = optional(string)
    cidr_blocks      = optional(list(string))
    ipv6_cidr_blocks = optional(list(string))
    prefix_list_ids  = optional(list(string))
    self             = optional(bool)
  }))

  default = []

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      can(r.rule_key) || (can(r.from_port) && can(r.to_port) && can(r.protocol))
    ])
    error_message = "Each egress rule must include either a rule_key or from_port/to_port/protocol."
  }
}
