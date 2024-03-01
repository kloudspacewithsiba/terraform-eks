terraform {
  backend "s3" {
    bucket = "mt-gitops-workflow"
    key = "mt-gitops-workflow/terraform.tfstate"
    region         = "eu-west-2"
    encrypt        = true
    dynamodb_table = "TerrastateLock"
  }
}