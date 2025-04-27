module "lambda_function" {
  source = "../../modules/lambda"
  function = local.lambda_function
  project               = "ticketing-triage"
  owner                 = local.owner
  function_runtime      = "python3.11"
  function_handler      = "jira_automation.lambda_handler"
  function_source_path  = ""
  lambda_role_arn       = module.iam.iam_role_arn

  tags = {
    Purpose = "Event handler for creating Jira Ticket from Github Issue"
  }
}