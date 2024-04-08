module "image_generation_lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "7.2.5"

  function_name = "image-generation-lambda"
  description   = "Generate images using AWS Bedrock"
  handler       = "image_generation.handler"
  runtime       = "python3.12"

  create_package         = false
  local_existing_package = "../artifact.zip"

  timeout = 900

  create_lambda_function_url = true
  cors = {
    # TODO: Use variables/locals
    allow_origins  = ["*"]
    allow_methods  = ["GET", "POST"]
    allow_headers  = ["*"]
    expose_headers = ["*"]
  }

  attach_policy = true
  policy        = "arn:aws:iam::aws:policy/AmazonBedrockFullAccess"
}

resource "cloudflare_record" "image_generation_lambda" {
  zone_id         = var.zone_id
  name            = "image_generation"
  value           = "${module.image_generation_lambda.lambda_function_url_id}.lambda-url.us-east-1.on.aws"
  type            = "CNAME"
  allow_overwrite = true
  proxied         = true
}
