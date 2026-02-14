
provider "aws" {
  region = var.region
}

module "vpc" {
  source     = "../../modules/vpc"
  name       = "${var.environment}-vpc"
  cidr_block = var.vpc_cidr_block
}

terraform {
  backend "s3" {
    bucket = "platform-iac-prod-tf-state"
    key    = "prod/terraform.tfstate"
    region = "us-east-1"

    use_lockfile = true
  }
}

