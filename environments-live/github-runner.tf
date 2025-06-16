resource "aws_iam_role" "github_runner" {
  name = "github-runner-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "github_runner_attach" {
  role       = aws_iam_role.github_runner.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess" # Or custom least-privilege policy
}

resource "aws_iam_instance_profile" "github_runner_profile" {
  name = "github-runner-profile"
  role = aws_iam_role.github_runner.name
}
resource "aws_instance" "github_runner" {
  ami                    = "ami-0c02fb55956c7d316"
  instance_type          = "t3.medium"
  iam_instance_profile   = aws_iam_instance_profile.github_runner_profile.name

  user_data = templatefile("${path.module}/../../bootstrap/gh_runner_user_data.sh", {
    GH_PAT_TOKEN = var.github_pat_token
    GH_OWNER     = var.github_owner
  })

  tags = {
    Name = "github-runner"
  }
}
