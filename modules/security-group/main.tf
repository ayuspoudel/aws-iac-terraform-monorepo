resource "aws_security_group" "this" {
  count = var.enabled && var.create_security_group ? 1 : 0
  name                    = var.name
  description             = var.description
  vpc_id                  = var.vpc_id
  revoke_rules_on_delete  = var.revoke_rules_on_delete
  tags                    = var.tags
}

resource "aws_security_group_rule" "ingress" {
  for_each = { for idx, rule in var.ingress_rules : idx => rule }
  self = try(each.value.self, false)
  depends_on = [aws_security_group.this]
  type              = "ingress"
  # from_port = try(each.value.from_port, local.predefined_rules[each.value.rule_key].from_port)
  # to_port   = try(each.value.to_port, local.predefined_rules[each.value.rule_key].to_port)
  # protocol  = try(each.value.protocol, local.predefined_rules[each.value.rule_key].protocol)

  from_port = each.value.from_port
  to_port   = each.value.to_port
  protocol  = each.value.protocol
  description       = each.value.description
  cidr_blocks       = try(each.value.cidr_blocks, var.default_cidr_blocks)
  ipv6_cidr_blocks  = try(each.value.ipv6_cidr_blocks, [])
  prefix_list_ids   = try(each.value.prefix_list_ids, [])
  security_group_id = local.this_sg_id
  lifecycle {
  create_before_destroy = true
  ignore_changes = [
    cidr_blocks,
    ipv6_cidr_blocks,
    prefix_list_ids
  ]
}

}


resource "aws_security_group_rule" "egress" {
  for_each = { for idx, rule in var.egress_rules : idx => rule }
  depends_on = [aws_security_group.this]
  type              = "egress"
  # from_port = try(each.value.from_port, local.predefined_rules[each.value.rule_key].from_port)
  # to_port   = try(each.value.to_port, local.predefined_rules[each.value.rule_key].to_port)
  # protocol  = try(each.value.protocol, local.predefined_rules[each.value.rule_key].protocol)
  from_port = each.value.from_port
  to_port   = each.value.to_port
  protocol  = each.value.protocol

  description       = each.value.description
  cidr_blocks       = try(local. predefined_rules[each.value.rule_key].cidr_blocks, var.default_cidr_blocks)
  ipv6_cidr_blocks  = try(local. predefined_rules[each.value.rule_key].ipv6_cidr_blocks, [])
  prefix_list_ids   = try(local. predefined_rules[each.value.rule_key].prefix_list_ids, [])
  security_group_id = local.this_sg_id
  lifecycle {
  create_before_destroy = true
  ignore_changes = [
    cidr_blocks,
    ipv6_cidr_blocks,
    prefix_list_ids
  ]
}

}
