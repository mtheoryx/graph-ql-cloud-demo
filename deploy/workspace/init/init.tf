resource "aws_dynamodb_table" "dynamodb-terraform-workspace-lock" {
  name           = "workspace-lock"
  hash_key       = "LockID"
  read_capacity  = 5
  write_capacity = 5

  attribute {
    name = "LockID"
    type = "S"
  }

  tags {
    Name        = "Stream Ops Worksapce Lock Table"
    Environment = "StreamOps Workspace"
    CostCenter  = "Engineer Marketing"
    Managed     = "Terraform v0.11.10"
  }
}
