output "bucket_name" {
  description = "Name of the S3 Bucket"
  value       = resource.aws_s3_bucket.website_bucket
}
