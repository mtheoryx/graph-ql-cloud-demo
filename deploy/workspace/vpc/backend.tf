provider "aws" {
  version = "~> 1.55"

  assume_role {
    role_arn = "${var.account_roles[terraform.workspace]}"
  }
}

provider "tls" {
  version = "~> 1.2"
}

provider "local" {
  version = "~> 1.1"
}

provider "null" {
  version = "~> 2.0"
}

terraform {
  required_version = "0.11.10"

  backend "s3" {
    bucket  = "tf-workspace-stream-graphql-demo"
    key     = "vpc/vpc.tfstate"
    region  = "us-east-2"
    encrypt = true
  }
}
