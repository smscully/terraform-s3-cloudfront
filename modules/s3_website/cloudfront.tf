########################################
# Create CloudFront
########################################
resource "aws_cloudfront_origin_access_control" "s3_oac" {
  name                              = "S3_OAC"
  description                       = "OAC for S3"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "website_distribution" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  origin {
    domain_name = aws_s3_bucket.website_bucket.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.website_bucket.bucket
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_oac.id
}

  logging_config {
    include_cookies = false
    bucket          = aws_s3_bucket.logging_bucket.bucket_regional_domain_name
    prefix          = "logging"
  }
/*
  custom_error_response {
    error_code = 403
    response_code = 403
    response_page_path = "/error.html"
  }
*/
  custom_error_response {
    error_code = 404
    response_code = 404
    response_page_path = "/error.html"
  }

  aliases = [ var.domain ]

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  default_cache_behavior {
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.website_bucket.id

    compress = true

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.domain_cert.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}
