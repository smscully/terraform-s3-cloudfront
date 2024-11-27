output "website_bucket_domain_name" {
  description = "Domain Name of the S3 Website Bucket."
  value       = resource.aws_s3_bucket.website_bucket.bucket_domain_name
}

output "distribution_domain_name" {
  description = "Domain Name of the CloudFront Distribution."
  value       = resource.aws_cloudfront_distribution.website_distribution.domain_name
}
