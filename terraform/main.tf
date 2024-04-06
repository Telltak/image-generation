module "image_generation_lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "7.2.5"

  function_name = "image-generation-lambda"
  description   = "Generate images using AWS Bedrock"
  handler       = "image_generation.handler"
  runtime       = "python3.12"

  create_package         = false
  local_existing_package = "../artifact.zip"

  attach_policy = true
  policy        = "arn:aws:iam::aws:policy/AmazonBedrockFullAccess"
}

data "aws_region" "current" {}

resource "cloudflare_record" "image_generation_lambda" {
  zone_id         = var.zone_id
  name            = "image-generation"
  value           = "${aws_apigatewayv2_api.image_generation_lambda.id}.execute-api.${data.aws_region.current.name}.amazonaws.com"
  type            = "CNAME"
  allow_overwrite = true
  proxied         = true
}
