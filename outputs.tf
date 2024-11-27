output "website_bucket_domain_name" {
  description = "Domain Name of the S3 Website Bucket."
  value       = module.s3_website.website_bucket_domain_name
}

output "cloudfront_distribution_domain_name" {
  description = "Domain Name of the CloudFront Distribution."
  value       = module.s3_website.distribution_domain_name
}
