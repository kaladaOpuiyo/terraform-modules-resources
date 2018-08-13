#####################################################################
# Common.Config sets up the standard configuration settings
#####################################################################

# create the instance types
output "instances" {
  value = {
    "data"    = "t2.micro"
    "app"     = "t2.micro"
    "web"     = "t2.micro"

  }
}
output "availability_zone" {
  value = {
    "az1" = "us-east-1a"

    "az2" = "us-east-1b"

    "az3" = "us-east-1c"

    "az4" = "us-east-1d" 

    "az5" = "us-east-1e" 

    "az6" = "us-east-1f" 
  }
}

################################################################
# Common.Instance gets the common data for each instance
################################################################

output "centOS_ami" {
  value = "ami-02e98f78"
}

output "user_file" {
  value = "${file("${path.module}/user_data.sh")}"
}


