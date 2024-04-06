variable "cf_api_token" {}

terraform {
  required_version = ">= 0.12"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.15.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">=4.0"
    }
  }

  backend "s3" {
    bucket = "telltak-terraform-state"
    key    = "image_generation/terraform.tfstate"
    region = "eu-west-1"

    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

provider "cloudflare" {
  api_token = var.cf_api_token
}

variable "zone_id" {
  default = "1e63670f45f5ba969a55ff0fe0809954"
  type    = string
}

provider "aws" {
  region = "us-east-1"
}
