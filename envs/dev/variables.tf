
variable "environment" {
  type        = string
  description = "Environment name (dev/prod)"
}

variable "vpc_cidr_block" {
  type        = string
  description = "VPC CIDR block for the environment"
}

variable "region" {
  type        = string
  description = "us-east-1 or such"
}
