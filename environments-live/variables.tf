variable "github_owner" {
  type    = string
  default = "ayuspoudel"
}

variable "github_pat_token" {
  type = string
}

variable "ami_id" {
  type    = string
  default = "ami-0c02fb55956c7d316" # Amazon Linux 2 (x86_64)
}
