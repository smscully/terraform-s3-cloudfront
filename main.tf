########################################
# Configure AWS Provider
########################################
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
  profile = var.profile
}

########################################
# Call Static Website Module
########################################
module "s3_website" {
  source           = "./modules/s3_website"
  bucket_name            = "${var.domain}-website-${var.stage}"
  bucket_name_logging            = "${var.domain}-logging-${var.stage}"
  zone_id = var.zone_id
  domain                 = var.domain
  source_files = var.source_files
}
