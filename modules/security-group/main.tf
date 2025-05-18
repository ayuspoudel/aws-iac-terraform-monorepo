resource "aws_security_group" "this" {
  count = var.enabled && var.create_security_group ? 1 : 0
  name                    = var.name
  description             = var.description
  vpc_id                  = var.vpc_id
  revoke_rules_on_delete  = var.revoke_rules_on_delete
  tags                    = var.tags
}

resource "aws_security_group_rule" "ingress" {
  for_each = toset(var.ingress_rules)

  type              = "ingress"
  from_port         = local. predefined_rules[each.value].from_port
  to_port           = local. predefined_rules[each.value].to_port
  protocol          = local. predefined_rules[each.value].protocol
  description       = local. predefined_rules[each.value].description
  cidr_blocks       = try(local. predefined_rules[each.value].cidr_blocks, var.default_cidr_blocks)
  ipv6_cidr_blocks  = try(local. predefined_rules[each.value].ipv6_cidr_blocks, [])
  prefix_list_ids   = try(local. predefined_rules[each.value].prefix_list_ids, [])
  security_group_id = local.this_sg_id
}

resource "aws_security_group_rule" "egress" {
  for_each = toset(var.egress_rules)

  type              = "egress"
  from_port         = local. predefined_rules[each.value].from_port
  to_port           = local. predefined_rules[each.value].to_port
  protocol          = local. predefined_rules[each.value].protocol
  description       = local. predefined_rules[each.value].description
  cidr_blocks       = try(local. predefined_rules[each.value].cidr_blocks, var.default_cidr_blocks)
  ipv6_cidr_blocks  = try(local. predefined_rules[each.value].ipv6_cidr_blocks, [])
  prefix_list_ids   = try(local. predefined_rules[each.value].prefix_list_ids, [])
  security_group_id = local.this_sg_id
}
