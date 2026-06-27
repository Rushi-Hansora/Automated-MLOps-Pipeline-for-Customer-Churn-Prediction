resource "aws_lambda_function" "churn_api" {

  function_name = var.lambda_function_name

  role = aws_iam_role.lambda_role.arn

  package_type = "Image"

  image_uri = "${aws_ecr_repository.churn_api.repository_url}:latest"

  timeout     = 60
  memory_size = 512

  architectures = ["x86_64"]

  environment {
    variables = {
      MODEL_BUCKET = var.model_bucket_name
    }
  }

  tags = {
    Name        = var.lambda_function_name
    Project     = "MLOps-Churn"
    Environment = "Production"
  }

  depends_on = [
    aws_iam_role_policy_attachment.lambda_logs,
    aws_iam_role_policy_attachment.lambda_s3
  ]
}