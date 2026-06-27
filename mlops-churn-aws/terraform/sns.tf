resource "aws_sns_topic" "mlops_alerts" {
  name = "mlops-alerts"

  tags = {
    Project = "MLOps-Churn"
  }
}

resource "aws_sns_topic_subscription" "email_notification" {
  topic_arn = aws_sns_topic.mlops_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}