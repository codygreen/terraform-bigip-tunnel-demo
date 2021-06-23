terraform {
  required_version = ">= 0.13"
  required_providers {
    aws = ">= 3.39.0"
  }
}

provider "aws" {
  region = var.aws_region
}

#
# Create a random id
#
resource "random_id" "id" {
  byte_length = 2
}

