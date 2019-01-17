provider "aws" {
  version = "~> 1.55"
}

terraform {
  required_version = "0.11.10"

  backend "s3" {
    bucket  = "tf-workspace-stream-graphql-demo"
    key     = "init.tfstate"
    region  = "us-east-2"
    encrypt = true
  }
}
