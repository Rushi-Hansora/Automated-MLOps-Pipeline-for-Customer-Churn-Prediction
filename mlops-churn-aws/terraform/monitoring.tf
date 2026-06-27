resource "aws_cloudwatch_metric_alarm" "lambda_errors" {
  alarm_name        = "ChurnAPI-HighErrors"
  alarm_description = "Lambda error rate too high"

  namespace   = "AWS/Lambda"
  metric_name = "Errors"
  statistic   = "Sum"

  period             = 300
  evaluation_periods = 1
  threshold          = 5

  comparison_operator = "GreaterThanThreshold"

  dimensions = {
    FunctionName = aws_lambda_function.churn_api.function_name
  }

  alarm_actions = [
    aws_sns_topic.mlops_alerts.arn
  ]

  treat_missing_data = "notBreaching"
}

resource "aws_cloudwatch_metric_alarm" "lambda_latency" {

  alarm_name = "ChurnAPI-HighLatency"

  namespace   = "AWS/Lambda"
  metric_name = "Duration"

  extended_statistic = "p99"

  period             = 300
  evaluation_periods = 1

  threshold = 2000

  comparison_operator = "GreaterThanThreshold"

  dimensions = {
    FunctionName = aws_lambda_function.churn_api.function_name
  }

  alarm_actions = [
    aws_sns_topic.mlops_alerts.arn
  ]

  treat_missing_data = "notBreaching"
}