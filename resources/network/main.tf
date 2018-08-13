##########################################################################
# Internet Gateway & VPC
##########################################################################

data "aws_vpc" "aux_vpc" {
  tags {
    Name = "${var.project}-vpc"
  }
}

data "aws_internet_gateway" "aux_igw" {
  tags {
    Name = "${var.project}-igw"
  }
}

##########################################################################
# Aux  Subnets
##########################################################################

resource "aws_subnet" "aux_subnet" {
  count                   = "${length(var.subnets)}"
  vpc_id                  = "${data.aws_vpc.aux_vpc.id}"
  cidr_block              = "${lookup(var.subnets["${element(keys(var.subnets),count.index)}"], "cidr_block")}"
  map_public_ip_on_launch = "${lookup(var.subnets["${element(keys(var.subnets),count.index)}"], "type")  == "public" ? true : false}"

  availability_zone = "${var.availability_zone}"

  tags = {
    Name        = "${var.project}-${var.az}-${element(keys(var.subnets),count.index)}"
    Environment = "${var.project}"
  }
}

##########################################################################
# AUX Route Tables
##########################################################################

resource "aws_route_table" "aux_route_table" {
  count = "${length(var.route_tables)}"

  vpc_id = "${data.aws_vpc.aux_vpc.id}"

  tags {
    Name        = "${var.project}-${element(var.route_tables, count.index)}-route-table"
    Environment = "${var.project}"
  }
}

##########################################################################
# AUX Routes
##########################################################################

resource "aws_route" "aux_route" {
  count = "${length(var.route_tables)}"

  route_table_id = "${element(aws_route_table.aux_route_table.*.id, count.index)}"

  destination_cidr_block = "${var.destination_cidr_block}"

  gateway_id = "${element(var.route_tables, count.index) 
                              == "public"  ? data.aws_internet_gateway.aux_igw.id: 
                  element(var.route_tables, count.index) 
                              == "private" ? "${join("",data.aws_nat_gateway.aux_ngw.*.id)}": "" }"
}

#########################################################################
# Nat Gateway
#########################################################################

data "aws_subnet" "nat_subnet" {
  count = "${var.create_nat_gateway}"

  tags {
    Name = "${var.project}-${var.az}-nat"
  }

  depends_on = ["aws_subnet.aux_subnet"]
}

data "aws_nat_gateway" "aux_ngw" {
  count = "${var.create_nat_gateway}"

  state = "available"

  tags {
    Name = "${var.project}-${var.az}-nat"
  }

  depends_on = ["aws_nat_gateway.aux_ngw"]
}

resource "aws_eip" "aux_ngw_eip" {
  count = "${var.create_nat_gateway}"
  vpc   = true

  tags = {
    Name        = "${var.project}-ngw-eip"
    Environment = "${var.project}"
  }

  depends_on = ["data.aws_internet_gateway.aux_igw"]
}

resource "aws_nat_gateway" "aux_ngw" {
  count         = "${var.create_nat_gateway}"
  subnet_id     = "${data.aws_subnet.nat_subnet.id}"
  allocation_id = "${aws_eip.aux_ngw_eip.id}"

  tags = {
    Name        = "${var.project}-ngw"
    Environment = "${var.project}"
  }

  depends_on = ["data.aws_internet_gateway.aux_igw"]
}

# ##########################################################################
# # Route Table Asoociations
# ##########################################################################

data "aws_route_table" "public" {
  count = "${contains(var.route_tables, "public") == true ? 1 : 0 }"

  tags {
    Name = "${var.project}-public-route-table"
  }

  depends_on = ["aws_route_table.aux_route_table"]
}

data "aws_route_table" "private" {
  count = "${contains(var.route_tables, "private") == true ? 1 : 0 }"

  tags {
    Name = "${var.project}-private-route-table"
  }

  depends_on = ["aws_route_table.aux_route_table"]
}

#############################################################################
# Route  Table Asoociations
#############################################################################
resource "aws_route_table_association" "aux_route_table_association" {
  count     = "${length(var.subnets)}"
  subnet_id = "${element(aws_subnet.aux_subnet.*.id, count.index)}"

  route_table_id = "${lookup(var.subnets["${element("${keys(var.subnets)}",count.index)}"], "type")  
                      == "public" ?join("",data.aws_route_table.public.*.id): 
                      lookup(var.subnets["${element("${keys(var.subnets)}",count.index)}"], "type")  
                      == "private" ?join("",data.aws_route_table.private.*.id): ""  }"

  depends_on = ["aws_route_table.aux_route_table", "aws_subnet.aux_subnet"]
}
