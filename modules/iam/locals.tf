

locals{
    iam_defined_tags  = {
          Environment = var.environment
          Team = var.team
          Owner = var.owner
          Managed_by = "Terraform"
    }
    
    iam_tags = merge(local.iam_defined_tags, var.tags)
    iam_user = "${local.iam_defined_tags.Environment}-${local.iam_defined_tags.Team}-${local.iam_defined_tags.Owner}"
    iam_ou   = "/${local.iam_defined_tags.Environment}-${local.iam_defined_tags.Team}/"
}