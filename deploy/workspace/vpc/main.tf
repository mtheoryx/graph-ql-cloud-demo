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

  # AZs
  tags {
    Name        = "The VPC"
    Environment = "${var.environment[terraform.workspace]}"
    Managed     = "Terraform v0.11.10"
  }
}

# igw
# required
# vpc_id
#
# optional
# tags
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name        = "The IGW"
    Environment = "${var.environment[terraform.workspace]}"
    Managed     = "Terraform v0.11.10"
  }
}

# public subnets (2)
resource "aws_subnet" "public" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${element(split(",",var.public_subnets_cidr[terraform.workspace]),count.index)}"
  availability_zone = "${element(split(",",var.azs[var.region]),count.index)}"
  count             = "${length(split(",",var.public_subnets_cidr[terraform.workspace]))}"

  # tags
  tags {
    Name        = "The Public Subnet(s)"
    Environment = "${var.environment[terraform.workspace]}"
    Managed     = "Terraform v0.11.10"
  }
}

# private subnets (2)
resource "aws_subnet" "private" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${element(split(",",var.private_subnets_cidr[terraform.workspace]),count.index)}"
  availability_zone = "${element(split(",",var.azs[var.region]),count.index)}"
  count             = "${length(split(",",var.private_subnets_cidr[terraform.workspace]))}"

  # tags
  tags {
    Name        = "The Private Subnet(s)"
    Environment = "${var.environment[terraform.workspace]}"
    Managed     = "Terraform v0.11.10"
  }
}

# routes
# route table
# route table associations
# security group(s)
# security group(s) rule(s)
# bastion
# EIP for bastion (caution, free only while attached)
# keys (tf-controlled, generated keys)

