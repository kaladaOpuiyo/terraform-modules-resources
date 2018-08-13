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

variable "release" {
  default = "canary"
}

module "aws_config" {
  source = "../../../resources/config/common"
}

##########################################################################
# Module VPC
##########################################################################

module "aws_vpc" {
  source = "../../../resources/vpc"

  vpc_cidr              = "10.111.0.0/16"
  enable_dns_support    = true
  enable_dns_hostnames  = true
  instance_tenancy      = "default"
  project               = "${var.env}-${var.release}"
  vpc_name              = "${var.env}-${var.release}-vpc"
  internet_gateway_name = "${var.env}-${var.release}-igw"
}
