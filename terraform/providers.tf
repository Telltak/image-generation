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
}

provider "cloudflare" {
  api_token = "XFT9H5TGEwl229G4KQ8RrebowgJMeRKSnDKud7_P"

}

variable "zone_id" {
  default = "1e63670f45f5ba969a55ff0fe0809954"
  type    = string
}

provider "aws" {
  region = "us-east-1"
}