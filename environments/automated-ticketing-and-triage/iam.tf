module "iam" {
  source = "../../modules/iam"

  owner        = "ayush"
  environment  = "prod"
  project      = "ticketing-triage"
  user_type    = "lambda"

  assume_role_policy_json = data.aws_iam_policy_document.lambda_assume_role.json

  role_policy_arns = {
    basic_execution = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  }

  role_policy_files = {
    custom_jira_permissions = "${path.module}/JiraGithubAutomation.json"
  }

  tags = {
    Purpose    = "Serverless Automation"
  }
}
