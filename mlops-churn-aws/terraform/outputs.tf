output "lambda_name" {
  value = aws_lambda_function.churn_api.function_name
}

output "lambda_arn" {
  value = aws_lambda_function.churn_api.arn
}

output "ecr_repository_url" {
  value = aws_ecr_repository.churn_api.repository_url
}

output "model_bucket" {
  value = aws_s3_bucket.model_bucket.bucket
}

output "api_endpoint" {
  value = aws_apigatewayv2_stage.default.invoke_url
}

output "github_actions_deploy_role_arn" {
  value = aws_iam_role.github_actions_deploy.arn
}