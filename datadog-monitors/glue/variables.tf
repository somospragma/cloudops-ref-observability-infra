variable "glue_failed_tasks_critical_threshold" {
  description = "Critical threshold for Glue failed tasks rate (%)"
  type        = number
  default     = 5
}

variable "glue_failed_tasks_warning_threshold" {
  description = "Warning threshold for Glue failed tasks rate (%)"
  type        = number
  default     = 2
}

variable "glue_killed_tasks_threshold" {
  description = "Critical threshold for Glue killed tasks (count)"
  type        = number
  default     = 0
}

variable "glue_elapsed_time_critical_threshold" {
  description = "Critical threshold for Glue job elapsed time (seconds)"
  type        = number
  default     = 14400 # 4 hours
}

variable "glue_elapsed_time_warning_threshold" {
  description = "Warning threshold for Glue job elapsed time (seconds)"
  type        = number
  default     = 7200 # 2 hours
}

variable "glue_heap_usage_critical_threshold" {
  description = "Critical threshold for Glue JVM heap usage (%)"
  type        = number
  default     = 90
}

variable "glue_heap_usage_warning_threshold" {
  description = "Warning threshold for Glue JVM heap usage (%)"
  type        = number
  default     = 80
}