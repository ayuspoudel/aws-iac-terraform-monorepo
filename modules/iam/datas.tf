data "local_file" "policies" {
  for_each = var.policy_files
  filename = each.value
}

data "local_file" "role_policies" {
  for_each = var.role_policy_files

  filename = each.value
}
