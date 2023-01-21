resource "aws_ecr_repository" "this" {
  for_each = var.ecr_repositories

  name                 = each.key
  image_tag_mutability = each.value.image_tag_mutability

  encryption_configuration {
    encryption_type = "AES256"
  }

  dynamic "image_scanning_configuration" {
    for_each = try([each.value.image_scanning_configuration], [])
    content {
      scan_on_push = try(image_scanning_configuration.value.scan_on_push, true)
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

resource "aws_ecr_lifecycle_policy" "this" {
  for_each = var.aws_ecr_repositories

  policy     = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Remove all images without label",
      "selection": {
        "tagStatus": "untagged",
        "countType": "sinceImagePushed",
        "countUnit": "days",
        "countNumber": 1
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
  EOF
  repository = each.key
  depends_on = [
    aws_ecr_repository.repository
  ]
}
