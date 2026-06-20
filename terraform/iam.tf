#.    Lambda execution role
resource "aws_iam_role" "lambda_exec"{
    name = "${var.project_name}-lambda-role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
                Service = "lambda.amazonaws.com"
            }
        }]
    })
}

resource "aws_iam_role_policy_attachment" "lambda_basic"{
    role = aws_iam_role.lambda_exec.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy" "lambda_s3"{
    name = "${var.project_name}-s3-read"

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Effect = "Allow"
            Action = ["s3:GetObject"]
            Resource = "${aws_s3_bucket.pipeline_input.arn}/*"
        }]
    })
}

resource "aws_iam_role_policy_attachment" "lambda_s3_attach"{
    role = aws_iam_role.lambda_exec.name
    policy_arn = aws_iam_policy.lambda_s3.arn
}

resource "aws_iam_policy" "lambda_dynamo"{
    name = "${var.project_name}-dynamo-write"

    policy = jsonencode({
        Version = "2012-10-17"
        Statement=[{
            Effect = "Allow"
            Action = ["dynamodb:PutItem", "dynamodb:BatchWriteItem"]
            Resource = aws_dynamodb_table.transactions.arn
        }]
    })
}

resource "aws_iam_role_policy_attachment" "lambda_dynamo_attach"{
    role = aws_iam_role.lambda_exec.name
    policy_arn = aws_iam_policy.lambda_dynamo.arn
}