resource "aws_vpc" "this" {
  for_each = var.vpcs

  name       = each.key
  cidr_block = each.value.cidr

  tags = merge(
    {
      "Name" = each.key
    },
    each.value.tags,
    var.common_tags
  )
}

resource "aws_vpc_ipv4_cidr_block_association" "this" {
  for_each = {
    for k, v in var.vpcs : k => v
    if length(v.secondary_cidr_blocks) > 0
  }

  vpc_id     = aws_vpc.this[each.key].id
  cidr_block = each.value.secondary_cidr_blocks
}

resource "aws_subnet" "private" {
  for_each = local.private_subnets

  vpc_id     = aws_vpc.this[each.value.vpc_name].id
  cidr_block = each.value.subnet_cidr

  tags = merge(
    {
      "Name" = each.key
    },
    var.common_tags
  )
}

resource "aws_subnet" "public" {
  for_each = local.public_subnets

  vpc_id     = aws_vpc.this[each.value.vpc_name].id
  cidr_block = each.value.subnet_cidr

  tags = merge(
    {
      "Name" = each.key
    },
    var.common_tags
  )
}

resource "aws_internet_gateway" "this" {
  for_each = {
    for k, v in var.vpcs : k => v
    if length(v.private_subnets) > 0
  }

  vpc_id = aws_vpc.this[each.key].id

  tags = merge(
    {
      "Name" = each.key
    },
    each.value.tags,
    var.common_tags
  )
}

# resource "aws_route" "public_internet_gateway" {
#   count = local.create_vpc && var.create_igw && length(var.public_subnets) > 0 ? 1 : 0

#   route_table_id         = aws_route_table.public[0].id
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = aws_internet_gateway.this[0].id

#   timeouts {
#     create = "5m"
#   }
# }