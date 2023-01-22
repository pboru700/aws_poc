module "vpc" {
  source = "git@github.com:pboru700/aws_poc.git//modules/aws/vpc?ref=vpc-1.0.0"

  vpcs = {
    prod = {
      cidr = "10.0.0.0/16"
      secondary_cidr_blocks = []
      public_subnets = {
        "us-east-1a" = "10.0.0.0/24"
        "us-east-1b" = "10.0.1.0/24"
        "us-east-1c" = "10.0.2.0/24"
      }
      private_subnets = {
        "us-east-1a" = "10.0.10.0/24"
        "us-east-1b" = "10.0.11.0/24"
        "us-east-1c" = "10.0.12.0/24"
      }

      tags = {
        "Purpose" = "POC"
      }
    }
  }

  common_tags = {
    Environment = "prod"
  }
}
