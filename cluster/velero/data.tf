resource "random_integer" "this" {
  min = 1
  max = 50000
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}
