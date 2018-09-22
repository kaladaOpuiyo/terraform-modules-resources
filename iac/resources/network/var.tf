variable "subnets" {
  description = "subnets"
  default     = {}
}

variable "route_tables" {
  default = []
}

variable "az" {
  description = "az"
}

variable "env_name" {
  description = "env_name"
}

variable "availability_zone" {
  description = "availability_zone"
}

variable "create_nat_gateway" {
  description = "create_nat_gateway"
}

variable "project" {
  description = "project"
}

variable "destination_cidr_block" {
  default = "0.0.0.0/0"
}
