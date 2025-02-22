# AWS Translate Project Documentation

## Overview
The AWS Translate Project is a serverless application that provides translation services through an API Gateway endpoint. The application uses AWS Lambda, Amazon Translate, and S3 buckets to process translation requests and store both original and translated texts.

## Architecture
The solution consists of the following AWS components:
- AWS Lambda function for processing translation requests
- Amazon Translate for text translation
- API Gateway for RESTful API endpoint
- Two S3 buckets for storing original and translated texts
- IAM roles and policies for security
- Lambda Layer for managing dependencies

## Components

### Lambda Function
The main Lambda function (`translate_Function`) handles incoming HTTP POST requests and processes them through two main Python files:

#### lambda_function.py
The primary handler that:
- Validates incoming requests
- Processes environment variables
- Handles error cases
- Coordinates the translation process
- Returns standardized API responses

#### translation_app.py
Contains the core translation logic:
- Interfaces with Amazon Translate service
- Manages S3 bucket uploads for both original and translated texts
- Handles AWS service interactions

### API Gateway
Provides a RESTful endpoint that:
- Accepts POST requests at the `/translate` path
- Routes requests to the Lambda function
- Returns translation results to clients

### Storage
Two S3 buckets are used:
- Request bucket: Stores original text submissions
- Response bucket: Stores translated results

## Infrastructure as Code
The project uses Terraform for infrastructure deployment, with the following key resources:

### Lambda Resources
- Main function configuration
- Lambda Layer for dependencies
- IAM roles and policies
- Environment variables configuration

### API Gateway Resources
- REST API configuration
- Method and integration setup
- Deployment and stage configuration

### Storage Resources
- S3 bucket creation and configuration
- Bucket policy management

## API Usage

### Endpoint
POST request to: `https://{api-gateway-url}/translate_prod/translate`

### Request Format
```json
{
    "src_locale": "en",
    "target_locale": "es",
    "input_text": "Hello, world!"
}
```

### Required Fields
- `src_locale`: Source language code (e.g., "en" for English)
- `target_locale`: Target language code (e.g., "es" for Spanish)
- `input_text`: Text to be translated

### Response Format
```json
{
    "statusCode": 200,
    "headers": {
        "Content-Type": "application/json"
    },
    "body": "¡Hola, mundo!"
}
```

## Error Handling
The application handles several types of errors:
- Invalid request format (400)
- Missing required fields (400)
- AWS service errors (500)
- Unexpected errors (500)

## Security
The project implements security through:
- IAM roles with least privilege access
- S3 bucket access restrictions
- API Gateway resource policies
- Lambda execution role permissions

## Dependencies
The application requires:
- Python 3.11 runtime
- boto3 library for AWS service interaction
- Additional dependencies managed through Lambda Layer

## Deployment
The infrastructure is deployed using Terraform:
1. Initialize Terraform: `terraform init`
2. Plan the deployment: `terraform plan`
3. Apply the configuration: `terraform apply`

## File Structure
```
aws-translate-project/
├── scripts/
│   ├── lambda_function.py
│   ├── translation_app.py
│   └── package/          # Lambda Layer dependencies
└── terraform/
    └── lambda.tf         # Infrastructure configuration
```

## Monitoring and Logging
The application utilizes:
- CloudWatch Logs for Lambda function logging
- API Gateway request logging
- S3 bucket access logging

## Future Improvements
Potential enhancements:
- Add authentication/authorization
- Implement request rate limiting
- Add support for batch translations
- Implement caching for frequently translated texts
- Add monitoring and alerting