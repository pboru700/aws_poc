locals {
  tags = merge(
    {
      "Name" = var.name
    },
    var.common_tags
  )
}
