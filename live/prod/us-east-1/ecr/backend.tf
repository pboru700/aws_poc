terraform {
  backend "s3" {
    bucket = "terraform-state-bucket"
    key    = "prod/us-east-1/ecr/terraform.tfstate"
    region = "us-east-1"
  }
}
