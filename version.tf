# Terraform and AWS Provider version being used
terraform {
  required_version = ">=1.3.2"
  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.42"
    }

  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "johnny-deployment"
}
