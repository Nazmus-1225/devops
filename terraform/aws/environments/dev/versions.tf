terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.72.1"
    }
    random = {
      source = "hashicorp/random"
      version = "3.6.3"
    }
  }

  backend "s3" {
    bucket = "terraform-state-buet-hack"
    key    = "development_environment"
    region = "ap-south-1"
  }

}