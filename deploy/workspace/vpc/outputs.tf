output "vpc.id" {
  value = "${aws_vpc.vpc.id}"
}

output "vpc.cidr_block" {
  value = "${aws_vpc.vpc.cidr_block}"
}
