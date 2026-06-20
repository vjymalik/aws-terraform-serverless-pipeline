import boto3
import csv
import os
import io
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

dynamodb = boto3.resource('dynamodb')
s3 = boto3.client('s3')

def lambda_handler(event, context):
    table_name = os.environ['DYNAMODB_TABLE']
    table = dynamodb.Table(table_name)

    for record in event['Records']:
        bucket = record['s3']['bucket']['name']
        key = record['s3']['object']['key']

        logger.info(f'Processing file: s3://{bucket}/{key}')

        response = s3.get_object(Bucket=bucket, Key=key)
        content = response['Body'].read().decode('utf-8')
        reader = csv.DictReader(io.StringIO(content))

        with table.batch_writer() as batch:
            for row in reader:
                item = {
                    'transaction_id' : row['transaction_id'],
                    'amount' : row['amount'],
                    'category' : row['category'],
                    'timestamp' : row['timestamp'],
                    'source_file' : key,
                }

                batch.put_item(Item = item)
                logger.info(f'Inserted: {item}')

    return {'statusCode': 200, 'body' : 'Done'}