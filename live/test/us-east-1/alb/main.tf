module "alb" {
  source = "git@github.com:pboru700/aws_poc.git//modules/aws/alb?ref=alb1.0.0"

  name       = "hello-world"
  vpc_id     = "vpc-abc123"
  subnet_ids = ["subnet-654321", "subnet-754321", "subnet-543218"]
  security_group = {
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
  }
  lb_config = {
    target_group = {
      port        = 80
      protocol    = "HTTP"
      target_type = "ip"
    }
    listener = {
      port            = 80
      protocol        = "HTTP"
      default_actions = "forward"
    }
  }

  common_tags = {
    Environment = "test"
  }
}
