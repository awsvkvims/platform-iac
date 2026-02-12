resource "vpc" "this" {
  cidr_block = var.cidr_block
  
  tags = {
    Name = var.name
  }
}
