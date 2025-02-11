data "aws_vpc" "vpc" {
  id = var.vpc
}

data "aws_subnets" "public_subnets" {
 filter {
   name   = "vpc-id"
   values = [var.vpc]
 }
 filter {
   name   = "tag:Name"
   values = ["*public*"]
 }
}

data "aws_ami" "ami_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
