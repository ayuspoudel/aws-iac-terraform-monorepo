

locals{
    iam_defined_tags  = {
          Owner        = var.owner
          Environment = var.environment
          Project      = var.project
          User_Type    = var.user_type
          Owner = var.owner
          Managed_by = "Terraform"
          CreatedDate  = timestamp()
    }
    
    # IAM User Naming
    iam_tags = merge(local.iam_defined_tags, var.tags)
    iam_user = "${local.iam_defined_tags.Project}-${local.iam_defined_tags.User_Type}"
    iam_ou   = "/${local.iam_defined_tags.Project}/"

    # IAM Role Naming
    iam_role = "${local.iam_defined_tags.Project}-${local.iam_defined_tags.User_Type}-role"
    iam_role_path = "/${local.iam_defined_tags.Project}/"
}