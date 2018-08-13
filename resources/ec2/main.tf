##########################################################################
#  VPC
##########################################################################
data "aws_vpc" "aux_vpc" {
  tags {
    Name = "${var.vpc_name}"
  }
}


##########################################################################
# aux Subnet
##########################################################################
data "aws_subnet" "aux_subnet" {
  count = "${var.instances_total}"

  tags {
    Name = "${var.subnet_name}"
  }
}

##########################################################################
#  aux Instance
##########################################################################
resource "aws_instance" "aux_instance" {
  ami = "${var.ami}"

  count = "${var.instances_total}"

  instance_type = "${var.instance_type}"

  key_name = "${var.key_name}"

  ebs_optimized = "${var.ebs_optimized}"

  tags {
    Name = "${var.tag_name}"
  }

  user_data = "${var.user_file}"

  network_interface {
    network_interface_id = "${element(aws_network_interface.primary.*.id, count.index)}"
    device_index         = 0
  }

  lifecycle {
    ignore_changes = ["user_data"]
  }
}

resource "aws_network_interface" "primary" {
  count = "${var.instances_total}"

  subnet_id       = "${element(data.aws_subnet.aux_subnet.*.id, count.index)}"
  security_groups = ["${element(aws_security_group.aux.*.id, count.index)}"]

  tags {
    Name = "${var.tag_name}${count.index+1}-primary-eni"
  }
}

##########################################################################
#  aux Security Group
##########################################################################

resource "aws_security_group" "aux" {
  count       = "${var.instances_total}"
  name        = "${var.tag_name}"
  description = "${var.tag_name} ports"
  vpc_id      = "${data.aws_vpc.aux_vpc.id}"

  tags {
    Name = "${var.tag_name}-ports"
  }
}

resource "aws_security_group_rule" "aux_ports_inbound" {
  count             = "${length(var.ports) * var.instances_total}"
  security_group_id = "${element(aws_security_group.aux.*.id, count.index)}"
  type              = "ingress"
  from_port         = "${replace(lookup(var.ports["${element(keys(var.ports),count.index)}"], "port_numbers") , "/^.*-.*/", 
                         element(split("-", lookup(var.ports["${element(keys(var.ports),count.index)}"], "port_numbers")), 0))}"
  to_port           = "${replace(lookup(var.ports["${element(keys(var.ports),count.index)}"], "port_numbers") , "/^.*-.*/", 
                         element(split("-", lookup(var.ports["${element(keys(var.ports),count.index)}"], "port_numbers")), 1))}"
  protocol          = "tcp"
  cidr_blocks       = ["${lookup(var.ports["${element(keys(var.ports),count.index)}"], "cidr_range")}"]
}

resource "aws_security_group_rule" "aux_ports_outbound" {
  count             = "${var.instances_total}"
  security_group_id = "${element(aws_security_group.aux.*.id, count.index)}"
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

