
# Lambda Function
resource  "aws_lambda_function" "translate_Function" {
  function_name = "translate_Function"
  handler       = "index.handler"
  runtime       = "python3.11"
  role          = aws_iam_role.lambda_role.arn

  filename = "lambda_function.zip" # Replace with your Lambda deployment package
  
  source_code_hash = data.archive_file.lambda.output_base64sha256

  layers = [aws_lambda_layer_version.lambda_layer.arn]

  environment {
    variables = {
      REQUEST_BUCKET  = "${aws_s3_bucket.requests_bucket.bucket}"
      RESPONSE_BUCKET = "${aws_s3_bucket.responses_bucket.bucket}"
    }
  }
}


### Lambda Layer for dependencies - upload the dependencies as a zip file 
resource "aws_lambda_layer_version" "lambda_layer" {
  filename   = "layers_dependencies.zip"
  layer_name = "translate_denpencies_layer"

  compatible_runtimes = ["python3.11"]
}

### archive_file takes a local/directory and zips it up for the lambda function
data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/../scripts/lambda_function.py"
  output_path = "lambda_function.zip"
}

### archive_file takes a local/directory and zips it up for the lambda function
data "archive_file" "layers" {
  type        = "zip"
  source_dir  = "${path.module}/../scripts/package"
  output_path = "layers_dependencies.zip"
}

# Define the IAM role for the Lambda function
resource "aws_iam_role" "lambda_role" {
  name = "lambda_translate_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Attach necessary policies to the IAM role
resource "aws_iam_role_policy_attachment" "s3_access" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = aws_iam_role.lambda_role.name
}

resource "aws_iam_role_policy_attachment" "translate_access" {
  policy_arn = "${aws_iam_policy.service_communication_policy.arn}"
  role       = aws_iam_role.lambda_role.name
}

# Attach basic Lambda execution policy
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


# Define the S3 buckets for requests and responses
resource "aws_s3_bucket" "requests_bucket" {
  bucket = "translation-requests-bucket"
  
  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket" "responses_bucket" {
  bucket = "translation-responses-bucket"
  
  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_iam_policy" "service_communication_policy" {
  name        = "lambda_s3_apigw_communication_policy"
  description = "Policy to allow Lambda, S3, and API Gateway to communicate"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # Lambda permissions
      {
        Effect   = "Allow",

        Action = [
          "lambda:InvokeFunction",
          "lambda:InvokeAsync"
        ],
        
        Resource = "*"
      },
      # S3 permissions
      {
        Effect   = "Allow",

        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket",
          "s3:DeleteObject"
        ],
        
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.requests_bucket.bucket}/*",
          "arn:aws:s3:::${aws_s3_bucket.responses_bucket.bucket}/*"
        ]
      },
      # API Gateway permissions
      # {
      #   Action = [
      #     "execute-api:Invoke",
      #     "execute-api:ManageConnections"
      #   ],
      #   Effect   = "Allow",
      #   Resource = [
      #     "arn:aws:execute-api:YOUR_REGION:YOUR_ACCOUNT_ID:YOUR_API_ID/*/*/*"
      #   ]
      # },
      # CloudWatch Logs permissions (for Lambda)
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect   = "Allow",
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}