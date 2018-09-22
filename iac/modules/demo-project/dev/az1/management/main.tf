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

variable "tier" {
  default = "management"
}

module "aws_config" {
  source = "../../../../../resources/config/common/"
}

##########################################################################
# Module Routes
##########################################################################

module "aws_app" {
  source = "../../../../../resources/ec2/"

  ##########################################################################
  # web Instances
  ##########################################################################

  instances_total   = 1
  instance_type     = "t2.micro"
  ami               = "${module.aws_config.centOS_ami}"
  env               = "${var.env}"
  az                = "${var.az}"
  ebs_optimized     = false
  subnet_name       = "${var.env}-${var.release}-${var.az}-${var.tier}"
  tag_name          = "${var.az}-${var.env}-${var.tier}-${var.release}"
  vpc_name          = "${var.env}-vpc"
  user_file         = "${module.aws_config.user_file}"
  key_name          = "kalada-admin"
  create_primary    = true
  attached_eni_name = ""
  ports = {
    ssh = {
      port_numbers = "22"
      cidr_range   = "0.0.0.0/0"
    }

    web80 = {
      port_numbers = "80"
      cidr_range   = "0.0.0.0/0"
    }
  }
}
