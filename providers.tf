terraform {
    backend "s3" {
    bucket = "valwitter-prom-server-tfstate"
    key    = "tfstate"
    region = "eu-west-2"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
      region = "eu-west-2"
    }
  }
}