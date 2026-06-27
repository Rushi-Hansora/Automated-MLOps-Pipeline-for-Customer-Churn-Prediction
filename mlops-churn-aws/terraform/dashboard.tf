resource "aws_cloudwatch_dashboard" "mlops_dashboard" {

  dashboard_name = "MLOps-Churn-Dashboard"

  dashboard_body = jsonencode({

    widgets = [

      {
        type = "metric"

        x = 0
        y = 0

        width  = 12
        height = 6

        properties = {

          title = "Lambda Invocations"

          metrics = [
            [
              "AWS/Lambda",
              "Invocations",
              "FunctionName",
              aws_lambda_function.churn_api.function_name
            ]
          ]

          period = 300
          stat   = "Sum"
          region = var.aws_region
        }
      },

      {
        type = "metric"

        x = 12
        y = 0

        width  = 12
        height = 6

        properties = {

          title = "Lambda Errors"

          metrics = [
            [
              "AWS/Lambda",
              "Errors",
              "FunctionName",
              aws_lambda_function.churn_api.function_name
            ]
          ]

          period = 300
          stat   = "Sum"
          region = var.aws_region
        }
      },

      {
        type = "metric"

        x = 0
        y = 6

        width  = 24
        height = 6

        properties = {

          title = "Lambda Duration"

          metrics = [
            [
              "AWS/Lambda",
              "Duration",
              "FunctionName",
              aws_lambda_function.churn_api.function_name
            ]
          ]

          stat   = "Average"
          period = 300
          region = var.aws_region
        }
      }

    ]
  })
}