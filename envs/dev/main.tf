
provider "aws" {
  region = var.region
}

module "vpc" {
  source     = "../../modules/vpc"
  cidr_block = var.cidr_block
  name       = "dev-vpc"
}

terraform {
  backend "s3" {
  bucket       = "platform-iac-dev-tf-state"
  key          = "dev/terraform.tfstate"
  region       = "us-east-1"

  use_lockfile = true
}
}
