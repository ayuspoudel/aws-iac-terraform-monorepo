# General Resource Naming
variable "name" {
  description = "Name prefix for all resources (e.g., instance, ASG, key pair)"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "The 'name' variable must not be empty."
  }
}

# Launch type: standalone EC2 instance, Auto Scaling Group, or Spot instance
variable "launch_type" {
  description = "Launch type: 'instance', 'asg', or 'spot'"
  type        = string
  default     = "instance"

  validation {
    condition     = contains(["instance", "asg", "spot"], var.launch_type)
    error_message = "launch_type must be one of: 'instance', 'asg', or 'spot'."
  }
}

# Required AMI and instance type
variable "ami" {
  description = "AMI ID to use for launching the EC2 instance"
  type        = string

  validation {
    condition     = length(var.ami) > 0
    error_message = "AMI ID must be provided and non-empty."
  }
}

variable "instance_type" {
  description = "EC2 instance type (e.g., t3.micro, m5.large)"
  type        = string
  default     = "t2.micro"
}

# Networking configuration
variable "subnet_id" {
  description = "Subnet ID to deploy the EC2 instance (for standalone or spot mode)"
  type        = string
  default     = null
}

variable "security_group_ids" {
  description = "List of security group IDs to associate with the instance"
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for sg in var.security_group_ids : length(sg) > 0])
    error_message = "All security group IDs must be non-empty strings."
  }
}

# Key pair configuration
variable "key_name" {
  description = "Name of existing key pair to use. If not provided and create_key_pair = true, one will be created"
  type        = string
  default     = null
}

variable "create_key_pair" {
  description = "Whether to create a new key pair"
  type        = bool
  default     = false
}

# IAM profile
variable "iam_instance_profile" {
  description = "Existing IAM instance profile name to attach"
  type        = string
  default     = null
}

variable "create_iam_instance_profile" {
  description = "Whether to create a new IAM instance profile"
  type        = bool
  default     = false
}

# Networking options
variable "associate_public_ip" {
  description = "Whether to associate a public IP with the instance"
  type        = bool
  default     = false
}

# User data
variable "user_data" {
  description = "Shell script or cloud-init user data to run on launch"
  type        = string
  default     = ""
}

# Monitoring
variable "monitoring" {
  description = "Enable detailed CloudWatch monitoring"
  type        = bool
  default     = false
}

# Root volume configuration
variable "root_volume" {
  type = object({
    size = number
    type = string
  })
  default = {
    size = 20
    type = "gp3"
  }

  validation {
    condition     = var.root_volume.size > 0
    error_message = "Root volume size must be greater than 0."
  }
}

# Optional data volume
variable "enable_data_volume" {
  description = "Enable additional data EBS volume"
  type        = bool
  default     = false
}

variable "data_volume" {
  type = object({
    size        = number
    type        = string
    device_name = string
  })
  default = {
    size        = 100
    type        = "gp3"
    device_name = "/dev/sdh"
  }

  validation {
    condition     = var.data_volume.size > 0 && length(var.data_volume.device_name) > 0
    error_message = "Data volume must have size > 0 and a valid device name."
  }
}

# AZ for EBS volume
variable "availability_zone" {
  description = "Availability zone for standalone EC2 or EBS volume"
  type        = string
  default     = null
}

# Auto Scaling Group settings
variable "asg_config" {
  type = object({
    desired_capacity = number
    max_size         = number
    min_size         = number
    subnet_ids       = list(string)
  })
  default = {
    desired_capacity = 1
    max_size         = 1
    min_size         = 1
    subnet_ids       = []
  }

  validation {
    condition     = var.asg_config.max_size >= var.asg_config.min_size
    error_message = "max_size must be greater than or equal to min_size."
  }
}

# Load balancer attachment
variable "attach_to_alb" {
  description = "Whether to attach ASG to a load balancer target group"
  type        = bool
  default     = false
}

variable "target_group_arn" {
  description = "ARN of the ALB or NLB target group"
  type        = string
  default     = ""
}

# Spot instance configuration
variable "spot_config" {
  type = object({
    spot_type             = string
    wait_for_fulfillment  = bool
    interruption_behavior = string
  })
  default = {
    spot_type             = "persistent"
    wait_for_fulfillment  = true
    interruption_behavior = "terminate"
  }

  validation {
    condition = contains(["one-time", "persistent"], var.spot_config.spot_type)
    error_message = "spot_type must be 'one-time' or 'persistent'."
  }
}

# Optional tagging
variable "tags" {
  description = "Additional tags to apply to resources"
  type        = map(string)
  default     = {}
}

# Lifecycle control
variable "lifecycle" {
  description = "EC2 lifecycle behavior configuration"
  type = object({
    create_before_destroy = bool
    prevent_destroy       = bool
  })
  default = {
    create_before_destroy = false
    prevent_destroy       = false
  }
}

variable "iam_role_name" {
  description = "Name of the IAM role to attach to the instance profile (required if create_iam_instance_profile is true)"
  type        = string
  default     = null

  validation {
    condition     = var.create_iam_instance_profile == false || (var.create_iam_instance_profile == true && length(var.iam_role_name) > 0)
    error_message = "You must provide 'iam_role_name' if 'create_iam_instance_profile' is true."
  }
}