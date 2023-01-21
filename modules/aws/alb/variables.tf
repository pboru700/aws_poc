variable "name" {
  type        = string
  description = "Name for module resources"
}

variable "vpc_id" {
  type        = string
  description = "ID for VPC for LoadBalancer deployment"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs to attach LoadBalancer"
}

variable "security_group" {
  type = map(object({
    ingress_rules = list(map(object({
      protocol    = optional(string, "tcp")
      from_port   = number
      to_port     = number
      cidr_blocks = list(string)
    })))
    egress_rules = list(map(object({
      protocol    = optional(string, "tcp")
      from_port   = number
      to_port     = number
      cidr_blocks = list(string)
    })))
  }))
  description = "Map of security group configs"
}

variable "lb_config" {
  type        = map(any)
  default     = {}
  description = "Map containing configuration for target groups and listeners"
}

variable "common_tags" {
  type        = map(string)
  default     = {}
  description = "Map of tags common among every resource"
}
