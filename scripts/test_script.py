
import boto3
import json

def translate_text(text, source_lang="en", target_lang="es"):
    translate = boto3.client('translate')
    result = translate.translate_text(
        Text=text,
        SourceLanguageCode=source_lang,
        TargetLanguageCode=target_lang
    )
    return result['TranslatedText']

if __name__ == "__main__":
    input_text = [
        {"text": "Hello, how are you?"},
        {"text": "I am learning about AWS Translate."}
    ]

    translated_data = []
    for item in input_text:
        translated_text = translate_text(item['text'])
        translated_data.append({
            "original": item['text'],
            "translated": translated_text
        })

    print(json.dumps(translated_data, indent=4, ensure_ascii=False))