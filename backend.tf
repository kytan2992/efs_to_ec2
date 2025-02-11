terraform {
  backend "s3" {
    bucket = "ky-s3-terraform"
    key    = "ky-tf-efs-to-ec2.tfstate"
    region = "us-east-1"
  }
}