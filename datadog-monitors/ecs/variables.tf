variable "ecs_cpu_critical_threshold" {
  description = "Critical threshold for ECS CPU utilization (%)"
  type        = number
  default     = 90
}

variable "ecs_cpu_warning_threshold" {
  description = "Warning threshold for ECS CPU utilization (%)"
  type        = number
  default     = 80
}

variable "ecs_memory_critical_threshold" {
  description = "Critical threshold for ECS memory utilization (%)"
  type        = number
  default     = 90
}

variable "ecs_memory_warning_threshold" {
  description = "Warning threshold for ECS memory utilization (%)"
  type        = number
  default     = 80
}

variable "ecs_running_task_critical_threshold" {
  description = "Critical threshold for ECS running task count"
  type        = number
  default     = 1
}

variable "ecs_pending_task_critical_threshold" {
  description = "Critical threshold for ECS pending task count (5 minutes)"
  type        = number
  default     = 1
}

variable "ecs_pending_task_warning_threshold" {
  description = "Warning threshold for ECS pending task count (2 minutes)"
  type        = number
  default     = 1
}