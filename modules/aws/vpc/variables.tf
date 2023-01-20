variable "vpcs" {
  type        = map(any)
  default     = {}
  description = "Object holding details for creating multiple vpcs with dependent objects"
}

variable "common_tags" {
  type        = map(string)
  default     = {}
  description = "Map of tags common among every resource"
}

variable "private_subnets" {
  type        = map(string)
  default     = {}
  description = "Map of private subnets to create"
}

variable "public_subnets" {
  type        = map(string)
  default     = {}
  description = "Map of public subnets to create"
}
