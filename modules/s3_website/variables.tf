variable "zone_id" {
  description = "ID of the AWS Hosted Zone."
  type        = string
}

variable "bucket_name_logging" {
  description = "Name of the logging bucket."
  type        = string
}

variable "bucket_name" {
  description = "Bucket name of the website."
  type        = string
}

variable "domain" {
  description = "Domain name of the website."
  type        = string
}

variable "source_files" {
  description = "Directory that contains the website files."
  type        = string
  default     = "website"
}
