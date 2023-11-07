terraform {

  backend "s3" {
    bucket = "terrafrom-dj"
    key    = "devopsdj.tfstate"
    region = "us-east-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


variable "sizeType" {
  type        = string
  default     = "t2.micro"
  description = "(optional) describe your variable"
}

provider "aws" {
  region = "us-east-1"
}



resource "aws_vpc" "test-vpc" {
  cidr_block = "192.168.24.0/24"

  tags = {
    Name = "testVPC-abc"
  }

}

/*
resource "aws_vpc" "test-vpc-1" {
  cidr_block = "192.168.25.0/24"

}

*/

/*
data "aws_ami" "ubuntu" {
  most_recent      = true
  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-*"]
  }
}


output "ubuntu_ami_id" {
  value = data.aws_ami.ubuntu.id

}

*/




/*
output "vpc-id" {

  value = aws_vpc.test-vpc.id

}
*/
/*
resource "aws_instance" "app_server" {
  ami           = "ami-04cb4ca688797756f"
  instance_type = var.sizeType

  tags = {
    Name = "ExampleAppServerInstance"
  }
}
*/