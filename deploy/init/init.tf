provider "aws" {
  version = "~> 1.55"
  region  = "us-east-2"
}

# Make a bucket
resource "aws_s3_bucket" "global-tf-state" {
  bucket = "tf-global-stream-graphql-demo"
  acl    = "private"

  lifecycle {
    prevent_destroy = true
  }

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags {
    Name        = "Terraform Remote State Global"
    Environment = "OPS"
    Managed     = "Terraform v0.11.10"
  }
}

# Make a table
resource "aws_dynamodb_table" "dynamodb-terraform-lock" {
  name           = "ops-terraform-lock"
  hash_key       = "LockID"
  read_capacity  = 5
  write_capacity = 5

  attribute {
    name = "LockID"
    type = "S"
  }

  tags {
    Name        = "Global Terraform Lock Table"
    Environment = "OPS"
    Managed     = "Terraform v0.11.10"
  }
}
