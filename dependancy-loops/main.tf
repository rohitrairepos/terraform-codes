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

provider "aws" {
  region = local.dev_region
}

resource "aws_vpc" "first" {
  cidr_block = local.vpc_cidr_block
  tags = {
    Name = "first-vpc"
  }

}

resource "aws_subnet" "first" {
  vpc_id            = aws_vpc.first.id // for subnet ,vpc id is implicit dependency 
  cidr_block        = local.subnet_cidr_block
  availability_zone = local.subnet_az

  tags = {
    "Name" = "first-subnet"
  }

}

resource "aws_instance" "first" {
  count             = 3
  ami               = data.aws_ami.ubuntu.id
  instance_type     = local.instance_size
  subnet_id         = aws_subnet.first.id // for aws_instance , subnet_id is implicit dependency 
  availability_zone = local.subnet_az     //optional 

  tags = {
    Name = "app-${count.index}"            //we will use interpolation 
  }


}