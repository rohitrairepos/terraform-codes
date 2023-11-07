terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

// provider block

provider "aws" {
  region = local.region
}

locals {
    region = "us-east-1"
    instance = "t3.micro"

}
/*
variable "ami" {
    type = string
    default = "ami-0fc5d935ebf8bc3bc"
  
}
*/

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


resource "aws_instance" "web-app" {
    ami = data.aws_ami.ubuntu.id
    instance_type = local.instance  //arguments (implicit )
    //availability_zone =  "us-east-1a"
    depends_on = [ aws_vpc.dev-kiosk , data.aws_ami.ubuntu ] //meta argument 

  
}


resource "aws_vpc" "dev-kiosk" {

    cidr_block = "10.0.0.0/16"

    tags = {
      Name = "dev-kiosk-vpc"
    }
  
}



/*
output "aws_region_name" {

    value = data.aws_region.current.name
  
}
*/