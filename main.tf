# Create S3 Buckets
resource "aws_s3_bucket" "buckets" {
  for_each = var.bucket_config

  bucket = each.key

  dynamic "logging" {
    for_each = var.logging_bucket != "" ? [1] : []
    content {
      target_bucket = var.logging_bucket
      target_prefix = "${each.key}/logs/"
    }
  }

  tags = merge(var.tags, { Name = each.key })
}

# Versioning configuration for each bucket
resource "aws_s3_bucket_versioning" "versioning" {
  for_each = var.bucket_config

  bucket = aws_s3_bucket.buckets[each.key].id

  versioning_configuration {
    status = each.value.versioning_enabled ? "Enabled" : "Suspended"
  }
}

# Public Access Policy 
resource "aws_s3_bucket_policy" "public_access" {
  for_each = { for bucket, config in var.bucket_config : bucket => config if config.enable_public_access }

  bucket = aws_s3_bucket.buckets[each.key].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.buckets[each.key].arn}/*"
      }
    ]
  })
}

# Static Website Hosting 
resource "aws_s3_bucket_website_configuration" "static_hosting" {
  for_each = { for bucket, config in var.bucket_config : bucket => config if config.enable_static_hosting }

  bucket = aws_s3_bucket.buckets[each.key].id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# Logging Policy
resource "aws_s3_bucket_policy" "bucket_logging_policy" {
  for_each = aws_s3_bucket.buckets

  bucket = each.value.id

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowLoggingAccess"
        Effect    = "Allow"
        Principal = {
          Service = "logging.s3.amazonaws.com"
        }
        Action    = "s3:PutObject"
        Resource  = "arn:aws:s3:::${each.value.bucket}/logs/*"
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = var.account_number
          }
        }
      }
    ]
  })
}
