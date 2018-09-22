##########################################################################
# Variables / Provider
##########################################################################
provider "aws" {
  region  = "us-east-1"
  version = "1.31.0"
}

variable "env" {
  default = "dev"
}

module "aws_config" {
  source = "../../../../resources/config/common"
}

##########################################################################
# Module VPC
##########################################################################

module "aws_aux_vpc" {
  source = "../../../../resources/vpc"

  vpc_cidr              = "10.111.0.0/16"
  enable_dns_support    = true
  enable_dns_hostnames  = true
  instance_tenancy      = "default"
  project               = "${var.env}"
  vpc_name              = "${var.env}-vpc"
  internet_gateway_name = "${var.env}-igw"
}

output "vpc_id" {
  value = "${module.aws_aux_vpc.aws_aux_vpc_id}"
}
