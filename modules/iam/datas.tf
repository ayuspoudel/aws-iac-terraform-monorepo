data "local_file" "policies" {
  for_each = var.policy_files
  filename = each.value
}