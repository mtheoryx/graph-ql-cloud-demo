variable "account_roles" {
  type        = "map"
  description = "Roles to assume per environment"

  default = {
    dev  = "arn:aws:iam::960226432182:role/deployer-admin-role"
    prod = "arn:aws:iam::534918726364:role/deployer-admin-role"
  }
}

variable "vpc_cidr" {
  type        = "map"
  description = "VPC CIDR blocks by environment"

  default = {
    dev  = "10.1.0.0/16"
    prod = "192.168.0.0/16"
  }
}

variable "environment" {
  type        = "map"
  description = "Environement of deployment"

  default {
    dev  = "Development"
    prod = "Production"
  }
}
