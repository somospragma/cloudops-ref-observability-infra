variable "environment" {
  description = "Environment name"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "notification_channels" {
  description = "List of notification channels"
  type        = list(string)
  default     = []
}

variable "critical_notification_channels" {
  description = "List of critical notification channels"
  type        = list(string)
  default     = []
}

variable "warning_notification_channels" {
  description = "List of warning notification channels"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "List of tags to apply to monitors"
  type        = list(string)
  default     = []
}

variable "default_message" {
  description = "Default message template for monitors"
  type        = string
}

# ALB Error Thresholds
variable "elb_5xx_errors_critical_threshold" {
  description = "Critical threshold for ELB 5xx errors (/min)"
  type        = number
  default     = 10
}

variable "elb_5xx_errors_warning_threshold" {
  description = "Warning threshold for ELB 5xx errors (/min)"
  type        = number
  default     = 5
}

variable "target_5xx_errors_critical_threshold" {
  description = "Critical threshold for target 5xx errors (/min)"
  type        = number
  default     = 10
}

variable "target_5xx_errors_warning_threshold" {
  description = "Warning threshold for target 5xx errors (/min)"
  type        = number
  default     = 5
}

variable "unhealthy_hosts_critical_threshold" {
  description = "Critical threshold for unhealthy hosts (count)"
  type        = number
  default     = 0
}

variable "target_response_time_critical_threshold" {
  description = "Critical threshold for target response time (ms)"
  type        = number
  default     = 5000
}

variable "target_response_time_warning_threshold" {
  description = "Warning threshold for target response time (ms)"
  type        = number
  default     = 2000
}

variable "request_count_critical_threshold" {
  description = "Critical threshold for request count"
  type        = number
  default     = 10000
}

variable "request_count_warning_threshold" {
  description = "Warning threshold for request count"
  type        = number
  default     = 7500
}