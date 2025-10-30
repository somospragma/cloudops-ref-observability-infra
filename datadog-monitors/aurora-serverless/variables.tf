variable "aurora_serverless_capacity_critical_threshold" {
  description = "Critical threshold for Aurora Serverless capacity (% of maximum)"
  type        = number
  default     = 90
}

variable "aurora_serverless_capacity_warning_threshold" {
  description = "Warning threshold for Aurora Serverless capacity (% of maximum)"
  type        = number
  default     = 80
}

variable "aurora_serverless_acu_critical_threshold" {
  description = "Critical threshold for Aurora Serverless ACU utilization (%)"
  type        = number
  default     = 90
}

variable "aurora_serverless_acu_warning_threshold" {
  description = "Warning threshold for Aurora Serverless ACU utilization (%)"
  type        = number
  default     = 80
}

variable "aurora_serverless_connections_critical_threshold" {
  description = "Critical threshold for Aurora Serverless database connections (count)"
  type        = number
  default     = 80
}

variable "aurora_serverless_connections_warning_threshold" {
  description = "Warning threshold for Aurora Serverless database connections (count)"
  type        = number
  default     = 70
}

variable "aurora_serverless_query_duration_critical_threshold" {
  description = "Critical threshold for Aurora Serverless query duration (seconds)"
  type        = number
  default     = 30
}

variable "aurora_serverless_query_duration_warning_threshold" {
  description = "Warning threshold for Aurora Serverless query duration (seconds)"
  type        = number
  default     = 10
}

variable "aurora_serverless_select_latency_critical_threshold" {
  description = "Critical threshold for Aurora Serverless SELECT latency (ms)"
  type        = number
  default     = 200
}

variable "aurora_serverless_select_latency_warning_threshold" {
  description = "Warning threshold for Aurora Serverless SELECT latency (ms)"
  type        = number
  default     = 100
}