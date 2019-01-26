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
resource "aws_security_group" "bastion-security-group" {
  name   = "${var.app_name}-bastion-sg"
  vpc_id = "${aws_vpc.vpc.id}"

  # tags
}

# security group(s) rule(s)
resource "aws_security_group_rule" "allow-ssh-bastion-ingress" {
  security_group_id = "${aws_security_group.bastion-security-group.id}"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow-all-bastion-egress" {
  security_group_id = "${aws_security_group.bastion-security-group.id}"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

# keys (tf-controlled, generated keys)
#
# locals var (for the key name/filepath)
locals {
  public_key_filename  = "bastion.pub"
  private_key_filename = "bastion.pem"
}

# generate key
resource "tls_private_key" "generated" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# create keypair
resource "aws_key_pair" "generated" {
  key_name   = "${var.ssh-key-name}"
  public_key = "${tls_private_key.generated.public_key_openssh}"

  lifecycle {
    ignore_changes = ["keyname"]
  }
}

# save to local public key
# save to local private key
resource "local_file" "bastion-private-key-file" {
  content  = "${tls_private_key.generated.private_key_pem}"
  filename = "${local.private_key_filename}"
}

# change permissions on private key
resource "null_resource" "chmod-key" {
  depends_on = ["local_file.bastion-private-key-file"]

  triggers {
    key = "${tls_private_key.generated.private_key_pem}"
  }

  provisioner "local-exec" {
    command = "chmod 600 ${local.private_key_filename}"
  }
}

#
# bastion
resource "aws_instance" "bastion" {
  ami                    = "ami-04328208f4f0cf1fe"
  subnet_id              = "${aws_subnet.public.0.id}"
  key_name               = "${aws_key_pair.generated.key_name}"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.bastion-security-group.id}"]

  tags {
    Name        = "${var.app_name}-${terraform.workspace}-bastion"
    Environment = "${var.environment[terraform.workspace]}"
    Managed     = "Terraform v0.11.10"
  }
}

#
# EIP for bastion (caution, free only while attached)
resource "aws_eip" "bastion-eip" {
  instance = "${aws_instance.bastion.id}"
  vpc      = true

  # tags
}
