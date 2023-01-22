terraform {
  backend "s3" {
    bucket = "terraform-state-bucket"
    key    = "test/us-east-1/vpc/terraform.tfstate"
    region = "us-east-1"
  }
}
