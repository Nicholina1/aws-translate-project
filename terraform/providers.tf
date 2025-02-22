
provider "aws" {
  region = var.region
}

# Create S3 Buckets
# resource "aws_s3_bucket" "requests_bucket" {
#   bucket = var.requests_bucket_name
#   acl    = "private"

#   tags = {
#     Name        = "TranslationRequestsBucket"
#     Environment = "Production"
#   }
# }

# resource "aws_s3_bucket" "responses_bucket" {
#   bucket = var.responses_bucket_name
#   acl    = "private"

#   tags = {
#     Name        = "TranslationResponsesBucket"
#     Environment = "Production"
#   }
# }

# Create IAM Role for Lambda
# resource "aws_iam_role" "lambda_role" {
#   name = "lambda-s3-translate-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           Service = "lambda.amazonaws.com"
#         }
#       }
#     ]
#   })
# }

# Attach Policies to IAM Role
# resource "aws_iam_role_policy_attachment" "s3_access" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
#   role       = aws_iam_role.lambda_role.name
# }

# resource "aws_iam_role_policy_attachment" "translate_access" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonTranslateFullAccess"
#   role       = aws_iam_role.lambda_role.name
# } 