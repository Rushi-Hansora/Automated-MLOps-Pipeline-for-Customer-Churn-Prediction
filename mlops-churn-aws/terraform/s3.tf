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

resource "aws_kms_key" "model_bucket" {

  description = "KMS key for MLOps model bucket"

  deletion_window_in_days = 30

  enable_key_rotation = true

  tags = {
    Project = "MLOps-Churn"
  }
}


resource "aws_s3_bucket_public_access_block" "model_bucket" {

  bucket = aws_s3_bucket.model_bucket.id

  block_public_acls = true

  block_public_policy = true

  ignore_public_acls = true

  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "model_bucket" {

  bucket = aws_s3_bucket.model_bucket.id

  rule {

    id = "archive-old-models"

    status = "Enabled"

    filter {
      prefix = "models/"
    }

    transition {

      days = 90

      storage_class = "GLACIER"
    }
  }

  rule {

    id = "expire-old-data"

    status = "Enabled"

    filter {
      prefix = "data/"
    }

    expiration {

      days = 180
    }
  }
}

resource "aws_s3_bucket_policy" "deny_insecure_transport" {

  bucket = aws_s3_bucket.model_bucket.id

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Sid = "DenyInsecureTransport"

        Effect = "Deny"

        Principal = "*"

        Action = "s3:*"

        Resource = [

          aws_s3_bucket.model_bucket.arn,

          "${aws_s3_bucket.model_bucket.arn}/*"
        ]

        Condition = {

          Bool = {

            "aws:SecureTransport" = "false"
          }
        }
      }
    ]
  })
}