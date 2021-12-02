resource "aws_s3_bucket" "private" {
  bucket = "private-${var.r_prefix}-terraform-yama"

  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  force_destroy = true
}
resource "aws_s3_bucket_public_access_block" "private" {
  bucket                  = aws_s3_bucket.private.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
resource "aws_s3_bucket" "public" {
  bucket = "public-${var.r_prefix}-terraform-yama"
  acl    = "public-read"
  cors_rule {
    allowed_origins = ["https://ymnk.fun"]
    allowed_methods = ["GET"]
    allowed_headers = ["*"]
    max_age_seconds = 3000
  }
  force_destroy = true
}
resource "aws_s3_bucket" "alb_log" {
  bucket = "alb-log-${var.r_prifix}-terraform-yama"

  lifecycle_rule {
    enabled = true

    expiration {
      days = "180"
    }
  }
  force_destroy = true
}
resource "aws_s3_bucket_policy" "alb_log" {
  bucket = aws_s3_bucket.alb_log.id
  policy = data.aws_iam_policy_document.alb_log.json
}

resource "aws_s3_bucket" "artifact" {
  bucket = "artifact-${var.r_prefix}-terraform-yama"

  lifecycle_rule {
    enabled = true

    expiration {
      days = "180"
    }
  }
  force_destroy = true
}