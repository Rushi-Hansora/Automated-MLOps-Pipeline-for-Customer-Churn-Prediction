########################################
# HTTP API Gateway
########################################

resource "aws_apigatewayv2_api" "churn_api" {
  name          = var.api_gateway_name
  protocol_type = "HTTP"

  tags = {
    Name        = var.api_gateway_name
    Project     = "MLOps-Churn"
    Environment = "Production"
  }
}

########################################
# Lambda Integration
########################################

resource "aws_apigatewayv2_integration" "lambda" {
  api_id                 = aws_apigatewayv2_api.churn_api.id
  integration_type       = "AWS_PROXY"
  integration_method     = "POST"
  integration_uri        = aws_lambda_function.churn_api.invoke_arn
  payload_format_version = "2.0"
}

########################################
# Default Route
########################################

resource "aws_apigatewayv2_route" "default" {
  api_id    = aws_apigatewayv2_api.churn_api.id
  route_key = "$default"
  target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"
}

########################################
# Default Stage
########################################

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.churn_api.id
  name        = "$default"
  auto_deploy = true
}

########################################
# Lambda Permission
########################################

resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowExecutionFromAPIGatewayTerraform"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.churn_api.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.churn_api.execution_arn}/*/*"
}