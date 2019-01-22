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

# Public Routing
resource "aws_route_table" "public-route-table" {
  vpc_id = "${aws_vpc.vpc.id}"

  # tags
}

resource "aws_route" "public-route" {
  route_table_id         = "${aws_route_table.public-route-table.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw.id}"
}

resource "aws_route_table_association" "public-route-assoc" {
  route_table_id = "${aws_route_table.public-route-table.id}"
  count          = "${length(split(",",var.public_subnets_cidr[terraform.workspace]))}"
  subnet_id      = "${element(aws_subnet.public.*.id,count.index)}"
}

# NAT
resource "aws_eip" "nat-eip" {
  vpc = true
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = "${aws_eip.nat-eip.id}"
  subnet_id     = "${aws_subnet.public.0.id}"

  # tags
}

# Private Routing
# Priavte route table
resource "aws_route_table" "private-route-table" {
  vpc_id = "${aws_vpc.vpc.id}"

  # tags
}

# Private route
resource "aws_route" "private-route" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = "${aws_route_table.private-route-table.id}"
  nat_gateway_id         = "${aws_nat_gateway.ngw.id}"
}

# Private route table associations
resource "aws_route_table_association" "private-route-assoc" {
  route_table_id = "${aws_route_table.private-route-table.id}"
  count          = "${length(split(",",var.private_subnets_cidr[terraform.workspace]))}"
  subnet_id      = "${element(aws_subnet.private.*.id,count.index)}"
}

# security group(s)
# security group(s) rule(s)
# bastion
# EIP for bastion (caution, free only while attached)
# keys (tf-controlled, generated keys)

