# Translation Service

A serverless application that provides text translation services using AWS Lambda and Amazon Translate. The service stores both original and translated texts in S3 buckets for record-keeping.

## Overview

This service consists of two main components:
- A Lambda function (`lambda_function.py`) that handles API requests and orchestrates the translation process
- A translation module (`translation_app.py`) that interfaces with Amazon Translate and handles S3 storage

## Prerequisites

- AWS Account with appropriate permissions
- Python 3.x
- AWS CLI configured
- The following AWS services:
  - AWS Lambda
  - Amazon Translate
  - Amazon S3
  - IAM roles with appropriate permissions

## Project Structure

```
scripts/
├── lambda_function.py
└── translation_app.py
```

## Environment Variables

The service requires the following environment variables:

- `REQUEST_BUCKET`: S3 bucket name for storing original text
- `RESPONSE_BUCKET`: S3 bucket name for storing translated text

## API Request Format

The service accepts JSON requests with the following structure:

```json
{
    "src_locale": "en",
    "target_locale": "es",
    "input_text": "Text to translate"
}
```

### Fields:
- `src_locale`: ISO code of the source language
- `target_locale`: ISO code of the target language
- `input_text`: Text to be translated

## Response Format

Successful responses will have a 200 status code and contain the translated text. Example:

```json
{
    "statusCode": 200,
    "headers": {
        "Content-Type": "application/json"
    },
    "body": "Translated text here"
}
```

## Error Handling

The service handles several types of errors:

- 400: Bad Request (missing fields, invalid format)
- 500: Server errors (AWS service errors, unexpected exceptions)

## Storage

The service automatically stores:
- Original text in the REQUEST_BUCKET with timestamp-based filenames
- Translated text in the RESPONSE_BUCKET with timestamp-based filenames

Files are stored with the naming format: `YYYY-MM-DD-HH-MM-SS.txt`

## AWS Configuration

- Region: eu-north-1
- Translate service configuration:
  - Max retry attempts: 10
  - Retry mode: standard
- SSL is enabled for all AWS service communications

## Development Notes

- The code includes comprehensive error handling and logging
- Type hints are used throughout the codebase
- Environment variables are validated at runtime
- Request validation ensures all required fields are present

## Error Messages

The service provides detailed error messages for common issues:
- Missing environment variables
- Invalid request format
- Missing required fields
- AWS service errors

## Security

- Uses SSL for all AWS service communications
- Implements AWS best practices for service configuration
- Validates all input before processing

## Dependencies

- boto3: AWS SDK for Python
- botocore: Low-level AWS operations
- json: JSON parsing and encoding
- datetime: Timestamp generation for file naming
- typing: Type hints support