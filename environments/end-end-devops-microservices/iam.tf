module "iam_user_admin" {
  source      = "./modules/iam"

  environment = "prj"
  team        = "home"
  owner       = "ayush"

  tags = {
    Terraform  = "true"
    CostCenter = "Amex"
  }

  policy_files = {
    AdministratorAccess = "./modules/iam/policies/AdministratorAccess.json"
  }
}