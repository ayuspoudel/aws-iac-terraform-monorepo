resource "aws_instance" "this" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_name == null ? null : var.key_name
  vpc_security_group_ids      = var.security_group_id != null ? [var.security_group_id] : [data.aws_security_group.default.id]
  subnet_id                   = var.subnet_id != null ? var.subnet_id : data.aws_subnets.default.ids[0]
  associate_public_ip_address = var.associate_public_ip
  user_data                   = var.user_data

  tags = merge(
    var.tags,
    {
      Name        = "${var.instance_prefix}-${var.environment}"
      Environment = var.environment
      Terraform   = "true"
    }
  )
}

# Attach Network Interface only if `associate_public_ip` is true
resource "aws_network_interface" "this" {
  count           = var.associate_public_ip ? 1 : 0
  subnet_id       = var.subnet_id != null ? var.subnet_id : data.aws_subnets.default.ids[0]
  security_groups = var.security_group_id != null ? [var.security_group_id] : [data.aws_security_group.default.id]

  tags = {
    Name = "${var.instance_prefix}-${var.environment}-nic"
  }
}

# Associate the network interface with the instance (if created)
resource "aws_network_interface_attachment" "this" {
  count                = var.associate_public_ip ? 1 : 0
  instance_id          = aws_instance.this.id
  network_interface_id = aws_network_interface.this[0].id
  device_index         = 0
}