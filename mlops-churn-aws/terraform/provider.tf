provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "MLOps-Churn"
      Environment = "Production"
      ManagedBy   = "Terraform"
    }
  }
}