module "ecr" {
  source = "git@github.com:pboru700/aws_poc.git//modules/aws/ecs?ref=ecs-1.0.0"

  cluster = {
    name = "hello-world"
  }

  ecs_tasks = {
    "hello-world" = {
      count                    = 2
      requires_compatibilities = "FARGATE"
      network_configuration = {
        subnet_ids = ["subnet-888888", "subnet-777777", "subnet-666666"] #private subnets
      }
      load_balancer = {
        target_group_arn = "arn:aws:elasticloadbalancing:us-west-1:123456789012:targetgroup/hello-world/20cfe21448b66314"
        container_port   = 8080
      }
      family                = "service"
      network_mode          = "awsvpc"
      container_definitions = yamldecode(templatefile("configs/hello-world-container-definition.yaml", {}))

      ingress_rules = [{
        protocol    = "tcp"
        from_port   = 8080
        to_port     = 8080
        cidr_blocks = ["0.0.0.0/0"]
      }]
      egress_rules = [{
        protocol    = "tcp"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
      }]

      tags = {
        "Purpose" = "POC"
      }
    }
  }

  common_tags = {
    Environment = "prod"
  }
}
