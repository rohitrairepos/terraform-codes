terraform {

  backend "s3" {
    bucket = "terrafrom-dj"
    key    = "loop.tfstate"
    region = "us-east-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

  }

  required_version = "~> 1.6.2"
}

provider "aws" {
  region = local.aws_region
}

locals {
  aws_region    = "us-east-1"
  ami_id        = "ami-08662cc7aed840314"
  instance_type = "t2.micro"
  tags          = "web-app"
}
/*
resource "aws_instance" "web" {
  count = 2
  ami = local.ami_id
  instance_type = local.instance_type

  tags = {
    Name = "${local.tags}-${count.index}"
  }
  
}
*/


/*
Example 2
fetch default vpc manaual managed. fetch all available zones. use 2 variable cidr to create subnets in all 
availability zone.
*/

data "aws_vpc" "default_vpc" {
  default = "true"

}

output "id" {

  value = data.aws_vpc.default_vpc.id

}

/*
variable "vpc_id" {
  type = string
  //default = data.aws_vpc.name.id

  
}
*/

// this code will create intance in each AZ in default VPC of us-east-1

locals {
  vpc_id = data.aws_vpc.default_vpc.id
}

data "aws_availability_zones" "az" {
  state = "available"

}



data "aws_subnets" "def_subnet" {
  filter {
    name   = "vpc-id"
    values = [local.vpc_id]
  }

}

data "aws_subnet" "def_subnet" {
  for_each = toset(data.aws_subnets.def_subnet.ids)
  id       = each.value
}

output "subnet_cidr_blocks" {
  value = [for s in data.aws_subnet.def_subnet : s.cidr_block]
}


resource "aws_instance" "app" {

  for_each      = toset(data.aws_subnets.def_subnet.ids)
  ami           = local.ami_id
  instance_type = local.instance_type
  subnet_id     = each.value


}
