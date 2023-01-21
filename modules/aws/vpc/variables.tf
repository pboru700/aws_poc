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
