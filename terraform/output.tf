
output "requests_bucket_name" {
  value = aws_s3_bucket.requests_bucket.bucket
}

output "responses_bucket_name" {
  value = aws_s3_bucket.responses_bucket.bucket
}

# output "lambda_function_arn" {
#   value = aws_lambda_function.translate_lambda.arn
# }