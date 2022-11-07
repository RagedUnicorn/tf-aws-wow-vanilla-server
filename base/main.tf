terraform {
  backend "s3" {
    bucket = "ragedunicorn-backend"
    key    = "wow-vanilla-server.terraform.tfstate"
    region = "eu-central-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

###############
# AWS provider
###############
provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.aws_region
}
