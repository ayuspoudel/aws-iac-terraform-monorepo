variable "sg_name" {
  description = "Security group name prefix"
  type        = string
  default     = "developer-sg"
}

variable "allowed_ips" {
  description = "List of allowed CIDR blocks for ingress rules"
  type        = list(string)
  default = [ ]
}

# Enable or disable specific rules
variable "enable_http" {
  description = "Enable HTTP access (port 80)"
  type        = bool
  default     = false
}

variable "enable_https" {
  description = "Enable HTTPS access (port 443)"
  type        = bool
  default     = false
}

variable "enable_ssh" {
  description = "Enable SSH access (port 22)"
  type        = bool
  default     = false
}

variable "enable_rdp" {
  description = "Enable RDP access (port 3389)"
  type        = bool
  default     = false
}

variable "enable_mysql" {
  description = "Enable MySQL access (port 3306)"
  type        = bool
  default     = false
}

variable "enable_postgresql" {
  description = "Enable PostgreSQL access (port 5432)"
  type        = bool
  default     = false
}

variable "enable_mongodb" {
  description = "Enable MongoDB access (port 27017)"
  type        = bool
  default     = false
}

variable "enable_winrm" {
  description = "Enable WinRM over HTTPS (port 5986)"
  type        = bool
  default     = false
}
