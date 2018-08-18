
data "aws_instance" "aux_instance" {

  tags {
    Name = "${var.instance_name}"
  }
}
data "aws_subnet" "aux_subnet" {
  count = "${var.instances_total}"

  tags {
    Name = "${var.subnet_name}"
  }
}

resource "aws_network_interface" "aux" {

  count = "${length(var.eni)}"
  subnet_id       = "${element(data.aws_subnet.aux_subnet.*.id, count.index)}"
  security_groups = ["${element(aws_security_group.aux.*.id, count.index)}"]
#   private_ips = ""
#   private_ips_count = ""
  source_dest_check = "${var.source_dest_check}"

  tags {
    Name = "${var.tag_name}${count.index+1}-eni"
  }
}

resource "aws_network_interface_attachment" "aux" {

    count = "${var.attach_interface == true ? length(var.eni) : false}"
    instance_id = "${data.aws_instance.aux_instance.id}"
    network_interface_id = "${aws_network_interface.aux.*.id}"
    device_index = "${var.eni_index}"
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
