output "security_group_id" {
  description = "ID of the security group created"
  value       = var.enabled && var.create_security_group ? aws_security_group.this[0].id : null
}

output "security_group_arn" {
  description = "ARN of the security group created"
  value       = var.enabled && var.create_security_group ? aws_security_group.this[0].arn : null
}

output "security_group_name" {
  description = "Name of the security group created or referenced"
  value       = var.name
}

output "ingress_rule_count" {
  description = "Number of ingress rules applied"
  value       = length(var.ingress_rules)
}

output "egress_rule_count" {
  description = "Number of egress rules applied"
  value       = length(var.egress_rules)
}

output "tags" {
  description = "Tags applied to the security group"
  value       = var.tags
}