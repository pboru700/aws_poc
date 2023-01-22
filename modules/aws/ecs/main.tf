resource "aws_ecs_cluster" "this" {
  name = var.cluster["name"]

  setting {
    name  = try(var.cluster.settings["name"], "containerInsights")
    value = try(var.cluster.settings["value"], "enabled")
  }

  tags = merge(
    {
      "Name" = var.name
    },
    var.common_tags
  )
}

resource "aws_ecs_service" "this" {
  for_each = var.ecs_tasks

  name            = each.key
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this[each.key].arn
  desired_count   = each.value.count
  launch_type     = each.value.requires_compatibilities

  dynamic "network_configuration" {
    for_each = var.ecs_tasks.network_configuration

    content {
      security_groups = [aws_security_group.this[each.key].id]
      subnets         = network_configuration.value.subnet_ids
    }
  }

  dynamic "load_balancer" {
    for_each = var.ecs_tasks.load_balancer

    content {
      target_group_arn = load_balancer.value.target_group_arn
      container_name   = each.key
      container_port   = load_balancer.value.container_port
    }
  }
}

resource "aws_ecs_task_definition" "this" {
  for_each = var.ecs_tasks

  family                   = each.value.family
  network_mode             = each.value.network_mode
  requires_compatibilities = [each.value.requires_compatibilities]
  cpu                      = try(each.value.cpu, "1024")
  memory                   = try(each.value.memory, "1024")
  container_definitions    = each.value.container_definitions

  tags = merge(
    {
      "Name" = each.key
    },
    each.value.tags,
    var.common_tags
  )
}

resource "aws_security_group" "this" {
  for_each = var.ecs_tasks

  name   = each.key
  vpc_id = each.value.vpc_id

  dynamic "ingress" {
    for_each = var.ecs_tasks.ingress_rules

    content {
      protocol    = try(ingress.value["protocol"], "tcp")
      from_port   = ingress.value["from_port"]
      to_port     = ingress.value["to_port"]
      cidr_blocks = ingress.value["cidr_blocks"]
    }
  }

  dynamic "egress" {
    for_each = var.ecs_tasks.egress_rules

    content {
      protocol    = try(egress.value["protocol"], "tcp")
      from_port   = egress.value["from_port"]
      to_port     = egress.value["to_port"]
      cidr_blocks = egress.value["cidr_blocks"]
    }
  }

  tags = merge(
    {
      "Name" = each.key
    },
    each.value.tags,
    var.common_tags
  )
}
