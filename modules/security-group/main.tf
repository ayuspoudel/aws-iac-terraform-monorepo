resource "aws_security_group" "this" {
  count = var.enabled && var.create_security_group ? 1 : 0
  name                    = var.name
  description             = var.description
  vpc_id                  = var.vpc_id
  revoke_rules_on_delete  = var.revoke_rules_on_delete
  tags                    = var.tags
}
resource "aws_security_group_rule" "ingress" {
  for_each = local.expanded_ingress_rules

  type              = "ingress"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  description       = try(each.value.description, "")
  security_group_id = local.this_sg_id

  dynamic "self" {
    for_each = try(each.value.self, false) ? [1] : []
    content {
      self = true
    }
  }

  dynamic "cidr_blocks" {
    for_each = try(each.value.self, false) ? [] : [1]
    content {
      cidr_blocks = try(each.value.cidr_blocks, var.default_cidr_blocks)
    }
  }

  dynamic "ipv6_cidr_blocks" {
    for_each = try(each.value.self, false) ? [] : [1]
    content {
      ipv6_cidr_blocks = try(each.value.ipv6_cidr_blocks, [])
    }
  }

  dynamic "prefix_list_ids" {
    for_each = try(each.value.self, false) ? [] : [1]
    content {
      prefix_list_ids = try(each.value.prefix_list_ids, [])
    }
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      cidr_blocks,
      ipv6_cidr_blocks,
      prefix_list_ids
    ]
  }

  depends_on = [aws_security_group.this]
}




resource "aws_security_group_rule" "egress" {
  for_each = local.expanded_egress_rules

  type              = "egress"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  description       = try(each.value.description, "")
  security_group_id = local.this_sg_id

  dynamic "self" {
    for_each = try(each.value.self, false) ? [1] : []
    content {
      self = true
    }
  }

  dynamic "cidr_blocks" {
    for_each = try(each.value.self, false) ? [] : [1]
    content {
      cidr_blocks = try(each.value.cidr_blocks, var.default_cidr_blocks)
    }
  }

  dynamic "ipv6_cidr_blocks" {
    for_each = try(each.value.self, false) ? [] : [1]
    content {
      ipv6_cidr_blocks = try(each.value.ipv6_cidr_blocks, [])
    }
  }

  dynamic "prefix_list_ids" {
    for_each = try(each.value.self, false) ? [] : [1]
    content {
      prefix_list_ids = try(each.value.prefix_list_ids, [])
    }
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      cidr_blocks,
      ipv6_cidr_blocks,
      prefix_list_ids
    ]
  }

  depends_on = [aws_security_group.this]
}

