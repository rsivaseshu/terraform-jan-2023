terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  backend "s3" {
    bucket = "rssr-tf-state-file-bucket"
    key    = "test-env/ec2"
    region = "ap-south-1"
    profile = "aws-dev-cred"
  }
}

provider "aws" {
  region  = "ap-south-1"
  profile = "aws-dev-cred"
}


