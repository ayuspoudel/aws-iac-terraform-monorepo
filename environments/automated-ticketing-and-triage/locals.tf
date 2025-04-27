locals {
  project_name = basename(path.module)
  owner = "ayush"
  user_type = "lambda-{function_name}-role"
  lambda_function = "jira-ticket-automation"
}
