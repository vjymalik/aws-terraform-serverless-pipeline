output "s3_bucket_name" {
  description = "Name of the S3 bucket that triggers the pipeline"
  value       = aws_s3_bucket.pipeline_input.bucket
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table storing processed transactions"
  value       = aws_dynamodb_table.transactions.name
}

output "lambda_function_name" {
  description = "Name of the deployed Lambda function"
  value       = aws_lambda_function.processor.function_name
}

output "sns_topic_arn" {
  description = "ARN of the SNS topic used for failure alerts"
  value       = aws_sns_topic.alerts.arn
}
