# @TODO: Document required/optional args

#
# -- Required Arguments --
# cidr_block
#
# -- Optional Arguments --
# instance_tenancy
# enable_dns_support
# enable_dns_hostnames
# enable_classiclink
# enable_classiclink_dns_support
# assign_generated_ipv6_cidr_block
# tags

resource "aws_vpc" "vpc" {
  cidr_block = "${var.vpc_cidr[terraform.workspace]}"

  tags {
    Name        = "The VPC"
    Environment = "${var.environment[terraform.workspace]}"
    Managed     = "Terraform v0.11.10"
  }
}
