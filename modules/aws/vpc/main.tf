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

resource "aws_subnet" "public" {
  for_each = local.public_subnets

  vpc_id            = aws_vpc.this[each.value.vpc_name].id
  cidr_block        = each.value.cidr
  availability_zone = each.value.availability_zone

  tags = merge(
    {
      "Name" = each.key
    },
    var.common_tags
  )
}

resource "aws_subnet" "private" {
  for_each = local.private_subnets

  vpc_id            = aws_vpc.this[each.value.vpc_name].id
  cidr_block        = each.value.cidr
  availability_zone = each.value.availability_zone

  tags = merge(
    {
      "Name" = each.key
    },
    var.common_tags
  )
}

resource "aws_internet_gateway" "this" {
  for_each = local.vpcs_containing_public_subnets

  vpc_id = aws_vpc.this[each.key].id

  tags = merge(
    {
      "Name" = each.key
    },
    each.value.tags,
    var.common_tags
  )
}

resource "aws_eip" "nat" {
  for_each = local.vpcs_containing_public_subnets

  vpc = true

  tags = merge(
    {
      "Name" = each.key
    },
    each.value.tags,
    var.common_tags
  )

  depends_on = [aws_internet_gateway.this[each.key].id]
}

resource "aws_nat_gateway" "this" {
  for_each = local.vpcs_containing_public_subnets

  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = element(local.public_subnet_ids[each.key], 0)

  tags = merge(
    {
      "Name" = each.key
    },
    each.value.tags,
    var.common_tags
  )
}

resource "aws_route_table" "public" {
  for_each = local.public_subnets

  vpc_id = aws_vpc.this[each.key].id

  tags = merge(
    {
      "Name" = each.key
    },
    each.value.tags,
    var.common_tags
  )
}

resource "aws_route_table" "private" {
  for_each = local.private_subnets

  vpc_id = aws_vpc.this[each.key].id

  tags = merge(
    {
      "Name" = each.key
    },
    each.value.tags,
    var.common_tags
  )
}

resource "aws_route" "public_igw" {
  for_each = local.public_subnets

  route_table_id         = aws_route_table.public[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[each.value.vpc_name].id

  timeouts {
    create = "5m"
  }
}

resource "aws_route" "private_nat" {
  for_each = local.private_subnets

  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat[each.key].id
}

resource "aws_route_table_association" "public" {
  for_each = local.public_subnets

  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public[each.key].id
}

resource "aws_route_table_association" "private" {
  for_each = local.private_subnets

  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private[each.key].id
}
