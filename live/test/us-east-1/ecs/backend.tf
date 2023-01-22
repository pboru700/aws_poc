terraform {
  backend "s3" {
    bucket = "terraform-state-bucket"
    key    = "test/us-east-1/ecs/terraform.tfstate"
    region = "us-east-1"
  }
}
