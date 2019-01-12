# JSON-SERVER api image repository
resource "aws_ecr_repository" "api-server" {
  name = "api-server"

  tags {
    Name        = "API Server ECR Repository"
    Environment = "OPS"
    Managed     = "Terraform v0.11.0"
  }
}

# GRAPHQL-SERVER image repository
resource "aws_ecr_repository" "graphql-server" {
  name = "graphql-server"

  tags {
    Name        = "Graphql Server ECR Repository"
    Environment = "OPS"
    Managed     = "Terraform v0.11.0"
  }
}
