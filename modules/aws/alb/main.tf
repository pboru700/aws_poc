resource "aws_lb" "this" {
  name            = var.name
  subnets         = var.subnet_ids
  security_groups = [aws_security_group.this.id]
  tags            = local.tags
}

resource "aws_security_group" "this" {
  name   = var.name
  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = var.security_group.ingress_rules

    content {
      protocol    = try(ingress.value["protocol"], "tcp")
      from_port   = ingress.value["from_port"]
      to_port     = ingress.value["to_port"]
      cidr_blocks = ingress.value["cidr_blocks"]
    }
  }

  dynamic "egress" {
    for_each = var.security_group.egress_rules

    content {
      protocol    = try(ingress.value["egress"], "tcp")
      from_port   = egress.value["from_port"]
      to_port     = egress.value["to_port"]
      cidr_blocks = egress.value["cidr_blocks"]
    }
  }

  tags = local.tags
}

resource "aws_lb_target_group" "this" {
  for_each = var.lb_config

  name        = each.key
  port        = each.value.target_group.port
  protocol    = each.value.target_group.proto
  vpc_id      = var.vpc_id
  target_type = each.value.target_group.target_type

  tags = merge(
    each.value.tags,
    var.common_tags
  )
}

resource "aws_lb_listener" "this" {
  for_each = var.lb_config

  load_balancer_arn = aws_lb.this.id
  port              = each.value.listener.port
  protocol          = each.value.listener.proto

  default_action {
    target_group_arn = aws_lb_target_group.thisp[each.key].id
    type             = each.value.listener.default_action
  }

  tags = merge(
    each.value.tags,
    var.common_tags
  )
}
