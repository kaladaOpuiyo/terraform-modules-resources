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
  source = "../../../../../../resources/config/common/"
}
# module "aws_eni_config" {
#   source  = "../../../../../../resources/eni"

# }
