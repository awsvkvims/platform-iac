
provider "aws" {
  region = var.region
}

module "vpc" {
  source = "../../modules/vpc"
  cidr_block = var.cidr_block
  name = "dev-vpc"
}
