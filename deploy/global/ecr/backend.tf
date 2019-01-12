provider "aws" {
  version = "~> 1.55"
}

terraform {
  required_version = "0.11.10"

  backend "s3" {
    bucket         = "tf-global-stream-graphql-demo"
    key            = "ecr/ecr.tfstate"
    region         = "us-east-2"
    encrypt        = true
    dynamodb_table = "ops-terraform-lock"
  }
}
