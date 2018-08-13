
variable "az" {
  description = "az"
}

variable "tag_name" {
  description = "tag_name"
}

variable "ports" {
  description = "ports"
  default = {} 
}

variable "key_name" {
  description = "key_name"
}


variable "env" {
  description = "env"
}

variable "vpc_name" {
  description = "vpc_name"
}

variable "ebs_optimized" {
  description = "ebs_optimized"
}

variable "subnet_name" {
  description = "subnet_name"
}

variable "instances_total" {
  description = "instances_total"
}

variable "instance_type" {
  description = "instance_type"
}

variable "user_file" {
  description = "user_file"
}

variable "ami" {
  description = "ami"
}

