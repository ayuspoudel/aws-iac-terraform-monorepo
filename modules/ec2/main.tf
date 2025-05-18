# main.tf

# Deploy a standalone EC2 instance (if launch_type is 'instance')
resource "aws_instance" "this" {
  count = var.launch_type == "instance" ? 1 : 0

  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id              = var.subnet_id != null ? var.subnet_id : data.aws_subnet.default.id
  vpc_security_group_ids = length(var.security_group_ids) > 0 ? var.security_group_ids : [data.aws_security_group.default.id]
  key_name                    = var.create_key_pair ? aws_key_pair.this[0].key_name : var.key_name
  monitoring                  = var.monitoring
  iam_instance_profile        = var.iam_instance_profile
  associate_public_ip_address = var.associate_public_ip

  user_data                   = var.user_data
  user_data_replace_on_change = true

  # Root EBS volume configuration
  root_block_device {
    volume_size = var.root_volume.size
    volume_type = var.root_volume.type
    encrypted   = true
  }

  # Lifecycle rules for instance replacement and protection
  lifecycle {
    create_before_destroy = true
    prevent_destroy       = false
  }

  tags = merge(local.default_tags, var.tags)
}

# Generate a new SSH key pair if requested
resource "tls_private_key" "this" {
  count     = var.create_key_pair ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create AWS key pair resource using the generated public key
resource "aws_key_pair" "this" {
  count      = var.create_key_pair ? 1 : 0
  key_name   = "${var.name}-key"
  public_key = tls_private_key.this[0].public_key_openssh
}

# Create a launch template for use with Auto Scaling Group
resource "aws_launch_template" "this" {
  count = var.launch_type == "asg" ? 1 : 0

  name_prefix   = "${var.name}-lt-"
  image_id      = var.ami
  instance_type = var.instance_type
  key_name      = var.create_key_pair ? aws_key_pair.this[0].key_name : var.key_name

  monitoring {
    enabled = var.monitoring
  }

  iam_instance_profile {
    name = var.iam_instance_profile
  }

  user_data = base64encode(var.user_data)

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = var.root_volume.size
      volume_type = var.root_volume.type
      encrypted   = true
    }
  }

  network_interfaces {
    security_groups             = var.security_group_ids
    associate_public_ip_address = var.associate_public_ip
  }

  tag_specifications {
    resource_type = "instance"
    tags          = merge(local.default_tags, var.tags)
  }
}

# Auto Scaling Group configuration
resource "aws_autoscaling_group" "this" {
  count               = var.launch_type == "asg" ? 1 : 0
  name                = "${var.name}-asg"
  desired_capacity    = var.asg_config.desired_capacity
  max_size            = var.asg_config.max_size
  min_size            = var.asg_config.min_size
  vpc_zone_identifier = var.asg_config.subnet_ids
  health_check_type   = "EC2"

  launch_template {
    id      = aws_launch_template.this[0].id
    version = "$Latest"
  }

  # Attach to ALB target group if requested
  target_group_arns = var.attach_to_alb ? [var.target_group_arn] : null

  tag {
    key                 = "Name"
    value               = var.name
    propagate_at_launch = true
  }
}

# Create a spot instance request if launch_type is 'spot'
resource "aws_spot_instance_request" "this" {
  count = var.launch_type == "spot" ? 1 : 0

  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids
  key_name                    = var.create_key_pair ? aws_key_pair.this[0].key_name : var.key_name
  iam_instance_profile        = var.iam_instance_profile
  associate_public_ip_address = var.associate_public_ip
  monitoring                  = var.monitoring
  user_data                   = var.user_data
  user_data_replace_on_change = true

  # Spot-specific parameters
  spot_type                      = var.spot_config.spot_type
  wait_for_fulfillment           = var.spot_config.wait_for_fulfillment
  instance_interruption_behavior = var.spot_config.interruption_behavior

  lifecycle {
    create_before_destroy = true
    prevent_destroy       = false
  }

  tags = merge(local.default_tags, var.tags)
}

# Optional data volume (EBS) provisioning
resource "aws_ebs_volume" "data" {
  count = var.enable_data_volume ? 1 : 0

  availability_zone = var.availability_zone
  size              = var.data_volume.size
  type              = var.data_volume.type
  encrypted         = true
  tags              = merge(local.default_tags, var.tags)
}

# Attach data volume to instance (only in standalone EC2 mode)
resource "aws_volume_attachment" "data" {
  count = var.enable_data_volume && var.launch_type == "instance" ? 1 : 0

  device_name = var.data_volume.device_name
  volume_id   = aws_ebs_volume.data[0].id
  instance_id = aws_instance.this[0].id
}
