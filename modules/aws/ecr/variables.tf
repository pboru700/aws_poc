variable "ecr_repositories" {
  type        = map(any)
  default     = {}
  description = "Map of ecr repositories to create"
}

variable "common_tags" {
  type        = map(string)
  default     = {}
  description = "Map of tags common among every resource"
}
