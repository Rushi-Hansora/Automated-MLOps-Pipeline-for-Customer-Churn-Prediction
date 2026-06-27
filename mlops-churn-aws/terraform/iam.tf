#######################################
# IAM Role for Lambda
#######################################

resource "aws_iam_role" "lambda_role" {
  name = "mlops-lambda-role-tf"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "lambda.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Project     = "MLOps-Churn"
    Environment = "Production"
  }
}

#######################################
# CloudWatch Logs Policy
#######################################

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role = aws_iam_role.lambda_role.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

#######################################
# S3 Read Policy
#######################################

resource "aws_iam_role_policy_attachment" "lambda_s3" {
  role = aws_iam_role.lambda_role.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}