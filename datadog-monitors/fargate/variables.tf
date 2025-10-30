variable "fargate_cpu_critical_threshold" {
  description = "Critical threshold for Fargate CPU utilization (%)"
  type        = number
  default     = 90
}

variable "fargate_cpu_warning_threshold" {
  description = "Warning threshold for Fargate CPU utilization (%)"
  type        = number
  default     = 80
}

variable "fargate_memory_critical_threshold" {
  description = "Critical threshold for Fargate memory utilization (%)"
  type        = number
  default     = 90
}

variable "fargate_memory_warning_threshold" {
  description = "Warning threshold for Fargate memory utilization (%)"
  type        = number
  default     = 80
}

variable "fargate_running_task_critical_threshold" {
  description = "Critical threshold for Fargate running task count"
  type        = number
  default     = 1
}

variable "fargate_pending_task_critical_threshold" {
  description = "Critical threshold for Fargate pending task count (5 minutes)"
  type        = number
  default     = 1
}

variable "fargate_pending_task_warning_threshold" {
  description = "Warning threshold for Fargate pending task count (2 minutes)"
  type        = number
  default     = 1
}