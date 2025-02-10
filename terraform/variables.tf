
variable "region" {
  description = "AWS Region for deployment"
  type        = string
  default     = "us-east-1"
}

variable "requests_bucket_name" {
  description = "Name of the S3 bucket for translation requests"
  type        = string
}

variable "responses_bucket_name" {
  description = "Name of the S3 bucket for translation responses"
  type        = string
}

variable "lambda_zip_file" {
  description = "Path to the Lambda function ZIP file"
  type        = string
  default = "/scripts/lambda_function.zip"
}