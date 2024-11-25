########################################
# Create S3 Bucket and Configure 
########################################
resource "aws_s3_bucket" "logging_bucket" {
  bucket = var.bucket_name_logging
  force_destroy = true
}

resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.logging_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket" "website_bucket" {
  bucket = var.bucket_name_website
}

resource "aws_s3_object" "source_files" {
  bucket                 = aws_s3_bucket.website_bucket.bucket
  for_each = fileset("${var.source_files}/", "**/*.*")
  key          = each.value
  source       = "${var.source_files}/${each.value}"
  server_side_encryption = "AES256"
  content_type = "text/html"
}

resource "aws_s3_bucket_website_configuration" "website_bucket_config" {
  bucket = aws_s3_bucket.website_bucket.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_public_access_block" "website_bucket_access" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "website_bucket_policy_document" {
  statement {
    principals {
      type = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    actions = ["s3:GetObject"]
    effect  = "Allow"
    resources = ["${aws_s3_bucket.website_bucket.arn}/*"]
  }
  statement {
    principals {
      type = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    actions = ["s3:ListBucket"]
    effect  = "Allow"
    resources = ["${aws_s3_bucket.website_bucket.arn}"]
  }
}

resource "aws_s3_bucket_policy" "website_bucket_policy" {
  bucket = aws_s3_bucket.website_bucket.id
  policy = data.aws_iam_policy_document.website_bucket_policy_document.json
}
