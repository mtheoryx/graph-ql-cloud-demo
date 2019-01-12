resource "aws_s3_bucket" "tf-workspace-stream-graphql-demo" {
  bucket = "tf-workspace-stream-graphql-demo"
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags {
    Name        = "Terraform Workspace Remote State"
    Environment = "OPS"
    Managed     = "Terraform v0.11.0"
  }
}
