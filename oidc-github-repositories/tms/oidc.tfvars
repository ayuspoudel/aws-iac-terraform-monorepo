inputs = {
  repo      = "ayuspoudel/tms"
  role_name = "github-oidc-tms-repo"
  policies = [ 
    # Amazon S3 full access
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",

    # Amazon DynamoDB full access. 
    "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess",

    # IAM full access (for managing users, roles, and policies)
    "arn:aws:iam::aws:policy/IAMFullAccess",

    # AWS Lambda full access
    "arn:aws:iam::aws:policy/AWSLambda_FullAccess",

    # Amazon EC2 Container Registry full access
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess",

    # API Gateway full access
    "arn:aws:iam::aws:policy/AmazonAPIGatewayAdministrator",

    # Cognito full access (for managing user pools, identity pools)
    "arn:aws:iam::aws:policy/AmazonCognitoPowerUser",

    # Simple Queue Service full access (for SQS)
    "arn:aws:iam::aws:policy/AmazonSQSFullAccess",

    # Simple Notification Service full access (for SNS)
    "arn:aws:iam::aws:policy/AmazonSNSFullAccess",

    # Full access to manage AWS CloudWatch logs
    "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
  ]
}
  