resource "aws_iam_user" "this" {
  count = var.create_iam_user ? 1 : 0

  name = local.iam_user
  path = local.iam_ou
  tags = local.iam_tags
}

resource "aws_iam_access_key" "this" {
  count = var.create_iam_user ? 1 : 0

  user = aws_iam_user.this[0].name
}

resource "aws_iam_user_policy" "inline_policies" {
  for_each = var.create_iam_user ? data.local_file.policies : {}

  name   = each.key
  user   = aws_iam_user.this[0].name
  policy = each.value.content
}

resource "random_password" "console_password" {
  count   = var.create_iam_user ? 1 : 0
  length  = 16
  special = true
}

resource "aws_iam_user_login_profile" "this" {
  count = var.create_iam_user ? 1 : 0

  user                    = aws_iam_user.this[0].name
  pgp_key                 = "keybase:your-keybase-username"
  password_reset_required = true
}

resource "aws_secretsmanager_secret" "iam_user_secret" {
  count = var.create_iam_user ? 1 : 0

  name        = "iam/${aws_iam_user.this[0].name}/credentials"
  description = "Access credentials for IAM user ${aws_iam_user.this[0].name}"
}

resource "aws_secretsmanager_secret_version" "iam_user_secret_version" {
  count = var.create_iam_user ? 1 : 0

  secret_id = aws_secretsmanager_secret.iam_user_secret[0].id

  secret_string = jsonencode({
    access_key_id     = aws_iam_access_key.this[0].id
    secret_access_key = aws_iam_access_key.this[0].secret
    console_password  = random_password.console_password[0].result
    iam_user          = aws_iam_user.this[0].name
  })
}
