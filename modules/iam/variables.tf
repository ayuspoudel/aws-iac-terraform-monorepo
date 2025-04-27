variable "environment"{
    description = "What environment is this user being creater for?"
    type = string
}

variable "team"{
    description = "What team is this user being creater for?"
    type = string
}

variable "owner"{
    description = "Who is the owner of this IAM user"
    type = string
}

variable "project" {
  description = "What project is this user for?"
  type = string
}

variable "user_type"{
    description =  "What kind of user is this?"
    type = string
}
variable "tags" {
  type        = map(string)
  description = "User-defined additional tags"
  default     = {}

  validation {
    condition = alltrue([
      !contains(keys(var.tags), "Environment"),
      !contains(keys(var.tags), "Team"),
      !contains(keys(var.tags), "Owner"),
      !contains(keys(var.tags), "Managed_by"),
      !contains(keys(var.tags), "Project"),
      !contains(keys(var.tags), "User_Type")
    ])
    error_message = "You cannot override reserved tags: Environment, Team, Owner, Managed_by"
  }
}

variable "policy_files" {
    description = "An Array of policy name to JSON File path"
    type = map(string)
}