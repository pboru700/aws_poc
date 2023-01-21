module "ecr" {
  source = "git@github.com:pboru700/aws_poc.git//modules/aws/ecr?ref=ecr1.0.0"

  ecr_repositories = yamldecode(templatefile("config/ecr_repositories.yaml", {}))

  common_tags = {
    Environment = "prod"
  }
}
