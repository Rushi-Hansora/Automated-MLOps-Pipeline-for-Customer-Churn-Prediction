variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "ap-south-1"
}

variable "model_bucket_name" {
  description = "S3 bucket for ML model"
  type        = string
  default     = "mlops-churn-rushi"
}

variable "ecr_repository_name" {
  description = "ECR Repository Name"
  type        = string
  default     = "mlops-churn-api"
}

variable "lambda_function_name" {
  description = "Lambda Function Name"
  type        = string
  default     = "churn-prediction-api-tf"
}

variable "api_gateway_name" {
  description = "API Gateway Name"
  type        = string
  default     = "churn-api-tf"

}

variable "lambda_role_name" {
  description = "IAM Role Name for Lambda"
  type        = string
  default     = "mlops-lambda-role-tf"
}