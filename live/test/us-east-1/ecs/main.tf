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
        subnet_ids = ["subnet-8888881", "subnet-7777771", "subnet-6666661"] #private subnets
      }
      load_balancer = {
        target_group_arn = "arn:aws:elasticloadbalancing:us-west-1:123456789013:targetgroup/hello-world/20cfe21448b66315"
        container_port   = 80
      }
      family                = "service"
      network_mode          = "awsvpc"
      container_definitions = yamldecode(templatefile("configs/hello-world-container-definition.yaml", {}))

      ingress_rules = [{
        protocol    = "tcp"
        from_port   = 80
        to_port     = 80
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
    Environment = "test"
  }
}
