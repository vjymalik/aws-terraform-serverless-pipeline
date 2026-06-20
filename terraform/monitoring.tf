
resource "aws_sns_topic" "alerts"{
    name = "${var.project_name}-alerts"
}

resource "aws_sns_topic_subscription" "email"{
    topic_arn = aws_sns_topic.alerts.arn
    protocol = "email"
    endpoint = var.alert_email
}


resource "aws_cloudwatch_metric_alarm" "lambda_errors"{
    alarm_name = "${var.project_name}-lambda-errors"
    comparison_operator = "GreaterThanThreshold"
    evaluation_periods = 1
    metric_name = "Errors"
    namespace = "AWS/Lambda"
    period = 60
    statistic = "Sum"
    threshold = 0
    alarm_description = "Fires when the pipeline Lambda function throws an error"
    alarm_actions = [aws_sns_topic.alerts.arn]
    treat_missing_data = "notBreaching"

    dimensions = {
        FunctionName = aws_lambda_function.processor.function_name
    }
}