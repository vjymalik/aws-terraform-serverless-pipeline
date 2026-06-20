provider "aws"{
    region = var.aws_region
}
#.     Random Suffix
resource "random_id" "suffix"{
    byte_length = 4
}
#.     S3 Bucket
resource "aws_s3_bucket" "pipeline_input"{
    bucket = "${var.project_name}-pipeline-input-${random_id.suffix.hex}"
    force_destroy=true
}
#.     Lambda trigger
resource "aws_s3_bucket_notification" "trigger"{
    bucket = aws_s3_bucket.pipeline_input.id

    lambda_function{
        lambda_function_arn = aws_lambda_function.processor.arn
        events = ["s3:ObjectCreated:*"]
        filter_suffix = ".csv"
    }

    depends_on = [aws_lambda_permission.allow_s3]
}
#.     Dynamodb Table
resource "aws_dynamodb_table" "transactions"{
    name = "${var.project_name}-transactions"
    billing_mode = "PROVISIONED"
    read_capacity = 5
    write_capacity = 5
    hash_key = "transaction_id"

    attribute{
        name = "transaction_id"
        type = "S"
    }
}
