# JSON-SERVER api image repository
resource "aws_ecr_repository" "api-server" {
  name = "api-server"

  lifecycle {
    prevent_destroy = true
  }

  tags {
    Name        = "API Server ECR Repository"
    Environment = "OPS"
    Managed     = "Terraform v0.11.0"
  }
}

# GRAPHQL-SERVER image repository
resource "aws_ecr_repository" "graphql-server" {
  name = "graphql-server"

  lifecycle {
    prevent_destroy = true
  }

  tags {
    Name        = "Graphql Server ECR Repository"
    Environment = "OPS"
    Managed     = "Terraform v0.11.0"
  }
}
