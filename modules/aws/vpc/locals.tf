locals {
  private_subnets = try(merge(flatten([
    for k, v in var.vpcs : {
      for subnet in v.private_subnets :
      "private-${k}-${subnet}" => {
        vpc_name    = k
        subnet_cidr = subnet
      }
    }
    if length(v.private_subnets) > 0
  ])), {})

  public_subnets = try(merge(flatten([
    for k, v in var.vpcs : {
      for subnet in v.public_subnets :
      "public-${k}-${subnet}" => {
        vpc_name    = k
        subnet_cidr = subnet
      }
    }
    if length(v.public_subnets) > 0
  ])), {})

  vpc_ids = { for k, v in var.vpcs : k => aws_vpc.this[k].id }
}
