variable "ecs_tasks" {
  type        = map(any)
  default     = {}
  description = "Map of configuration for ecs tasks"
}

variable "common_tags" {
  type        = map(string)
  default     = {}
  description = "Map of tags common among every resource"
}
