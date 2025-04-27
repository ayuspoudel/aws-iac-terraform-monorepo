resource "aws_iam_user" "this" {
  name = local.iam_user
  path = local.iam_ou
  tags = local.iam_tags
}

resource "aws_iam_access_key" "this" {
  user = aws_iam_user.this.name
}

resource "aws_iam_user_policy" "inline_policies"{
  for_each = data.local_file.policies
  name = each.key
  user = aws_iam_user.this.name
  policy = each.value.content
}

resource "random_password" "console_password" {
  length  = 16
  special = true
}

resource "aws_iam_user_login_profile" "this" {
  user                    = aws_iam_user.this.name
  pgp_key                 = "keybase:your-keybase-username"
  password_reset_required = true
}

resource "aws_secretsmanager_secret" "iam_user_secret" {
  name = "iam/${aws_iam_user.this.name}/credentials"
  description = "Access credentials for IAM user ${aws_iam_user.this.name}"
}

resource "aws_secretsmanager_secret_version" "iam_user_secret_version" {
  secret_id = aws_secretsmanager_secret.iam_user_secret.id

  secret_string = jsonencode({
    access_key_id     = aws_iam_access_key.this.id
    secret_access_key = aws_iam_access_key.this.secret
    console_password  = random_password.console_password.result
    iam_user          = aws_iam_user.this.name
  })
}

#The problem is that this creates the user but unfortunately the user does not have console access. You need to redo this to get console access to the user