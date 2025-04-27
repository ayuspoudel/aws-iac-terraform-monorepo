

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
    
    iam_tags = merge(local.iam_defined_tags, var.tags)
    iam_user = "${local.iam_defined_tags.project}-${local.iam_defined_tags.User_Type}"
    iam_ou   = "/${local.iam_defined_tags.project}/"
}