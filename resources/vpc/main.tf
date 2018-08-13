resource "aws_vpc" "aux_vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_support   = "${var.enable_dns_support}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  instance_tenancy     = "${var.instance_tenancy}"

  tags {
    Name        = "${var.vpc_name}"
    Environment = "${var.project}"
  }
}

resource "aws_internet_gateway" "aux_igw" {
  vpc_id = "${aws_vpc.aux_vpc.id}"

  tags {
    Name        = "${var.internet_gateway_name}"
    Environment = "${var.project}"
  }
}
