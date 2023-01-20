locals {
  public_subnets = try(merge(flatten([
    for k, v in var.vpcs : {
      for az, cidr in v.public_subnets :
      "public-${k}-${az}" => {
        vpc_name          = k
        cidr              = cidr
        availability_zone = az
      }
    }
    if length(v.public_subnets) > 0
  ])), {})
  private_subnets = try(merge(flatten([
    for k, v in var.vpcs : {
      for az, cidr in v.private_subnets :
      "private-${k}-${az}" => {
        vpc_name          = k
        cidr              = cidr
        availability_zone = az
      }
    }
    if length(v.private_subnets) > 0
  ])), {})

  vpcs_containing_public_subnets = {
    for k, v in var.vpcs : k => v
    if length(v.public_subnets) > 0
  }

  vpc_ids = { for k, v in var.vpcs : k => aws_vpc.this[k].id }
  public_subnet_ids = try(merge(flatten({
    for vpc_k, vpc_v in var.vpcs : vpc_k => [
      for subnet_k, subnet_v in local.public_subnets : aws_subnet.public[subnet_sk].id
      if subnet_v.vpc_name == vpc_k
    ]
  })), {})
  private_subnet_ids = try(merge(flatten({
    for vpc_k, vpc_v in var.vpcs : vpc_k => [
      for subnet_k, subnet_v in local.private_subnets : aws_subnet.private[subnet_k].id
      if subnet_v.vpc_name == k
    ]
  })), {})
}
