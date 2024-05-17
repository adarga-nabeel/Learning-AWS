import json

def lambda_handler(event, context):
    cloud_bucket_names = [{"cloud_provider": "aws", "bucket": "s3"}, {"cloud_provider": "azure", "bucket": "blob"}]
    return {
        'statusCode': 200,
        'body': json.dumps(cloud_bucket_names)
    }