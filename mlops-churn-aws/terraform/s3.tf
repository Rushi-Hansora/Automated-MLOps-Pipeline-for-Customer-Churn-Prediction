resource "aws_s3_bucket" "model_bucket" {
  bucket = var.model_bucket_name

  tags = {
    Name        = var.model_bucket_name
    Project     = "MLOps-Churn"
    Environment = "Production"
  }
}

resource "aws_s3_bucket_versioning" "model_bucket_versioning" {
  bucket = aws_s3_bucket.model_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "model_bucket_encryption" {
  bucket = aws_s3_bucket.model_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}