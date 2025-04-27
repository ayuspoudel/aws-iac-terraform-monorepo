resource "aws_security_group" "this" {
  name_prefix = var.sg_name
}

# Conditional Ingress Rules
resource "aws_security_group_rule" "http_ingress" {
  count             = var.enable_http ? 1 : 0
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol         = "tcp"
  cidr_blocks      = length(var.allowed_ips) > 0 ? var.allowed_ips : local.default_allowed_ip
  security_group_id = aws_security_group.this.id
}

resource "aws_security_group_rule" "https_ingress" {
  count             = var.enable_https ? 1 : 0
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol         = "tcp"
  cidr_blocks      = length(var.allowed_ips) > 0 ? var.allowed_ips : local.default_allowed_ip
  security_group_id = aws_security_group.this.id
}

resource "aws_security_group_rule" "ssh_ingress" {
  count             = var.enable_ssh ? 1 : 0
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol         = "tcp"
  cidr_blocks      = length(var.allowed_ips) > 0 ? var.allowed_ips : local.default_allowed_ip
  security_group_id = aws_security_group.this.id
}

resource "aws_security_group_rule" "rdp_ingress" {
  count             = var.enable_rdp ? 1 : 0
  type              = "ingress"
  from_port         = 3389
  to_port           = 3389
  protocol         = "tcp"
  cidr_blocks      = length(var.allowed_ips) > 0 ? var.allowed_ips : local.default_allowed_ip
  security_group_id = aws_security_group.this.id
}

resource "aws_security_group_rule" "mysql_ingress" {
  count             = var.enable_mysql ? 1 : 0
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol         = "tcp"
  cidr_blocks      = length(var.allowed_ips) > 0 ? var.allowed_ips : local.default_allowed_ip
  security_group_id = aws_security_group.this.id
}

resource "aws_security_group_rule" "postgresql_ingress" {
  count             = var.enable_postgresql ? 1 : 0
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol         = "tcp"
  cidr_blocks      = length(var.allowed_ips) > 0 ? var.allowed_ips : local.default_allowed_ip
  security_group_id = aws_security_group.this.id
}

resource "aws_security_group_rule" "mongodb_ingress" {
  count             = var.enable_mongodb ? 1 : 0
  type              = "ingress"
  from_port         = 27017
  to_port           = 27017
  protocol         = "tcp"
  cidr_blocks      = length(var.allowed_ips) > 0 ? var.allowed_ips : local.default_allowed_ip
  security_group_id = aws_security_group.this.id
}

resource "aws_security_group_rule" "winrm_https_ingress" {
  count             = var.enable_winrm ? 1 : 0
  type              = "ingress"
  from_port         = 5986
  to_port           = 5986
  protocol         = "tcp"
  cidr_blocks      = length(var.allowed_ips) > 0 ? var.allowed_ips : local.default_allowed_ip
  security_group_id = aws_security_group.this.id
}

# Allow All Outbound Traffic
resource "aws_security_group_rule" "allow_all_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol         = "-1"
  cidr_blocks      = ["0.0.0.0/0"]
  security_group_id = aws_security_group.this.id
}
