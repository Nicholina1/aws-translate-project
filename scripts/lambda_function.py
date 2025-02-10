
import boto3
import json

def lambda_handler(event, context):
    s3 = boto3.client('s3')
    translate = boto3.client('translate')

    # Get the object from the event
    bucket_name = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']
    print(bucket_name)
    print(key)
    try:
        # Download the file from S3
        obj = s3.get_object(Bucket=bucket_name, Key=key)
        file_content = obj['Body'].read().decode('utf-8')
        data = json.loads(file_content)
        print(data)
        # Translate each sentence
        translated_data = []
        for item in data:
            result = translate.translate_text(
                Text=item['text'],
                SourceLanguageCode="en",  # Change as needed
                TargetLanguageCode="es"   # Change as needed
            )
            translated_data.append({
                "original": item['text'],
                "translated": result['TranslatedText']
            })
        print(translated_data)
        # Save the translated data to a new JSON file
        output_key = f"translated_{key}"
        s3.put_object(
            Bucket=context.function_name.split('-')[0],  # Use environment variable for bucket name
            Key=output_key,
            Body=json.dumps(translated_data, ensure_ascii=False).encode('utf-8')
        )

        return {
            'statusCode': 200,
            'body': json.dumps(f"File {key} translated successfully!")
        }

    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps(f"Error processing file: {str(e)}")
        }



