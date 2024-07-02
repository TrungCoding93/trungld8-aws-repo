# TODO: Designate a cloud provider, region, and credentials
variable "region" {
    default = "us-east-1"
}

provider "aws" {
    region = var.region
    shared_credentials_files = ["../credential_file/credentials"]
}

# TODO: provision 4 AWS t2.micro EC2 instances named Udacity T2
resource "aws_instance" "Udacity_T2" {
    count = "4"
    ami = "ami-08a0d1e16fc3f61ea"
    instance_type = "t2.micro"
    tags = {
      Name = "Udacity T2"
    }
}

# TODO: provision 2 m4.large EC2 instances named Udacity M4
resource "aws_instance" "Udacity_M4" {
    count = "2"
    ami = "ami-08a0d1e16fc3f61ea"
    instance_type = "m4.large"
    tags = {
      Name = "Udacity M4"
    }
}