variable "region" {
  default = "us-east-2"
}

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
    dev  = "10.0.0.0/16"
    prod = "10.1.0.0/16"
  }
}

variable "public_subnets_cidr" {
  type        = "map"
  description = "Public subnet cidr blocks by environment"

  default = {
    dev  = "10.0.1.0/24,10.0.2.0/24"
    prod = "10.1.1.0/24,10.1.2.0/24"
  }
}

variable "private_subnets_cidr" {
  type        = "map"
  description = "Private subnet cidr blocks by environment"

  default = {
    dev  = "10.0.3.0/24,10.0.4.0/24"
    prod = "10.1.3.0/24,10.1.4.0/24"
  }
}

variable "azs" {
  type        = "map"
  description = "Available AZs per region"

  default = {
    us-east-2 = "us-east-2a,us-east-2b,us-east-2c"
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
