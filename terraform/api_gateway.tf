resource "aws_apigatewayv2_api" "image_generation_lambda" {
  name          = "image_generation"
  protocol_type = "HTTP"
  target        = module.image_generation_lambda.lambda_function_arn
}

resource "aws_lambda_permission" "image_generation_lambda" {
  action        = "lambda:InvokeFunction"
  function_name = module.image_generation_lambda.lambda_function_arn
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.image_generation_lambda.execution_arn}/*/*"
}

resource "aws_apigatewayv2_domain_name" "image_generation_lambda" {
  domain_name = "image-generation.telltak.space"
  domain_name_configuration {
    certificate_arn = "arn:aws:acm:us-east-1:792211320931:certificate/a04e9642-e2cd-4ce4-b165-725eba59d457"
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

