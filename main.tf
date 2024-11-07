########################################
# Configure AWS Provider
########################################
provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

########################################
# Call S3 Website Module
########################################
module "s3_website" {
  source           = "./modules/s3-website"
  bucket_name = "russetleaf.com.static.website"
  index_document = "index.html"
  error_document = "404.html"
}

########################################
# Call CloudFront Module
########################################
module "cloudfront" {
  source           = "./modules/cloudfront"
  bucket_name = "russetleaf.com.static.website"
  index_document = "index.html"
  error_document = "404.html"
  domain             = ""
}

########################################
# Call Route 53 and ACM Module
########################################
module "Ingress_Rule_Pub" {
  source            = "./modules/sg_rule"
  domain             = ""
}
