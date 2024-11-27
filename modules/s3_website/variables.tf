variable "zone_id" {
  description = "ID of the AWS Hosted Zone."
  type        = string
}

variable "bucket_name_website" {
  description = "Bucket name for website files."
  type        = string
}

variable "bucket_name_logging" {
  description = "Bucket name for log files."
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

variable "http_response" {
  type    = list(number)
  default = [400, 403, 404, 405, 414, 416, 500, 501, 502, 503, 504]
}

