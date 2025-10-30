# Lambda Error Rate thresholds (%)
variable "lambda_error_rate_critical_threshold" {
  description = "Critical threshold for Lambda error rate (%)"
  type        = number
  default     = 5
}

variable "lambda_error_rate_warning_threshold" {
  description = "Warning threshold for Lambda error rate (%)"
  type        = number
  default     = 2
}

# Lambda Throttles thresholds (count)
variable "lambda_throttles_critical_threshold" {
  description = "Critical threshold for Lambda throttles (count)"
  type        = number
  default     = 0
}

# Lambda Dead Letter Queue Errors thresholds (count)
variable "lambda_dlq_errors_critical_threshold" {
  description = "Critical threshold for Lambda DLQ errors (count)"
  type        = number
  default     = 0
}

# Lambda Duration thresholds (milliseconds)
variable "lambda_duration_critical_threshold" {
  description = "Critical threshold for Lambda duration (ms) - 80% of timeout"
  type        = number
  default     = 240000 # 4 minutes (80% of 5min default timeout)
}

variable "lambda_duration_warning_threshold" {
  description = "Warning threshold for Lambda duration (ms) - 70% of timeout"
  type        = number
  default     = 210000 # 3.5 minutes (70% of 5min default timeout)
}

# Lambda Concurrent Executions thresholds (count)
variable "lambda_concurrent_critical_threshold" {
  description = "Critical threshold for Lambda concurrent executions (count)"
  type        = number
  default     = 800 # 80% of 1000 default limit
}

variable "lambda_concurrent_warning_threshold" {
  description = "Warning threshold for Lambda concurrent executions (count)"
  type        = number
  default     = 700 # 70% of 1000 default limit
}

# Lambda Iterator Age thresholds (milliseconds)
variable "lambda_iterator_age_critical_threshold" {
  description = "Critical threshold for Lambda iterator age (ms)"
  type        = number
  default     = 60000 # 60 seconds
}

variable "lambda_iterator_age_warning_threshold" {
  description = "Warning threshold for Lambda iterator age (ms)"
  type        = number
  default     = 30000 # 30 seconds
}