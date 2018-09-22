##########################################################################
# Variables
##########################################################################
provider "aws" {
  region  = "us-east-1"
  version = "1.31.0"
}

variable "env" {
  default = "dev"
}

variable "az" {
  default = "az1"
}

variable "release" {
  default = "canary"
}

module "aws_config" {
  source = "../../../../../resources/config/common"
}

##########################################################################
# Module Routes
##########################################################################

module "aws_routes" {
  source = "../../../../../resources/network"

  project           = "${var.env}-${var.release}"
  availability_zone = "${module.aws_config.availability_zone["${var.az}"]}"

  az = "${var.az}"

  env_name = "${var.env}"

  # private and/or public
  route_tables = ["public"]

  ##########################################################################
  # Subnets
  ##########################################################################

  # If a private route table is needed set to true and create a subnet called nat for the nat gateway
  # (index_number)-name_of_subnet
  create_nat_gateway = false
  subnets = {
    "1-app" = {
      cidr_block = "10.111.32.0/24"
      type       = "public"
    }

    "2-web" = {
      cidr_block = "10.111.16.0/24"
      type       = "public"
    }

    "3-management" = {
      cidr_block = "10.111.80.0/24"
      type       = "public"
    }
  }
}
