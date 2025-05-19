output "security_group_arn" {
  description = "The ARN of the security group"
  value       = var.enabled && var.create_security_group ? aws_security_group.this[0].arn : null
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = var.enabled && var.create_security_group ? aws_security_group.this[0].id : null
}

output "security_group_vpc_id" {
  description = "The VPC ID where the SG resides"
  value       = var.enabled && var.create_security_group ? aws_security_group.this[0].vpc_id : null
}

output "security_group_owner_id" {
  description = "The AWS account ID of the SG owner"
  value       = var.enabled && var.create_security_group ? aws_security_group.this[0].owner_id : null
}

output "security_group_name" {
  description = "The name of the security group"
  value       = var.enabled && var.create_security_group ? aws_security_group.this[0].name : null
}

output "security_group_description" {
  description = "The description of the security group"
  value       = var.enabled && var.create_security_group ? aws_security_group.this[0].description : null
}
