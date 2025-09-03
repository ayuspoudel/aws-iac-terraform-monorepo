terraform {
  source = "../../modules/oidc-github"
}

include {
  path = find_in_parent_folders("root.hcl")
}

inputs = read_terragrunt_config("oidc.tfvars").inputs