variable "ami" {
  description = "Amazon Machine Image ID for the instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "SSH Key Pair Name for access"
  type        = string
}

variable "security_group_id" {
  description = "Security Group ID to attach to the instance"
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "Subnet ID where the instance will be deployed"
  type        = string
  default     = null
}

variable "associate_public_ip" {
  description = "Whether to associate a public IP address"
  type        = bool
  default     = false

}

variable "user_data" {
  description = "User data script to execute on instance launch"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Additional tags to assign to the instance"
  type        = map(string)
  default     = {}
}

variable "environment" {
  description = "The environment (e.g., dev, staging, prod)"
  type        = string
}

variable "instance_prefix" {
  description = "Prefix of the instance"
  type        = string
}