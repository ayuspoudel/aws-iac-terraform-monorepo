resource "aws_iam_role" "this" {
  name               = local.iam_role
  assume_role_policy = var.assume_role_policy_json
  path               = local.iam_role_path
  tags               = local.iam_tags
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = var.role_policy_arns

  role       = aws_iam_role.this.name
  policy_arn = each.value
}

resource "aws_iam_role_policy" "inline_policies" {
  for_each = data.local_file.role_policies

  name = each.key
  role = aws_iam_role.this.name
  policy = each.value.content
}
