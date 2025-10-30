# DynamoDB Throttled Requests threshold (count)
variable "dynamodb_throttled_requests_threshold" {
  description = "Critical threshold for DynamoDB throttled requests (count)"
  type        = number
  default     = 0
}

# DynamoDB System Errors threshold (count)
variable "dynamodb_system_errors_threshold" {
  description = "Critical threshold for DynamoDB system errors (count)"
  type        = number
  default     = 0
}

# DynamoDB User Error Rate thresholds (%)
variable "dynamodb_user_error_rate_critical_threshold" {
  description = "Critical threshold for DynamoDB user error rate (%)"
  type        = number
  default     = 5
}

variable "dynamodb_user_error_rate_warning_threshold" {
  description = "Warning threshold for DynamoDB user error rate (%)"
  type        = number
  default     = 2
}

# DynamoDB Read Capacity thresholds (%)
variable "dynamodb_read_capacity_critical_threshold" {
  description = "Critical threshold for DynamoDB consumed read capacity (%)"
  type        = number
  default     = 80
}

variable "dynamodb_read_capacity_warning_threshold" {
  description = "Warning threshold for DynamoDB consumed read capacity (%)"
  type        = number
  default     = 70
}

# DynamoDB Write Capacity thresholds (%)
variable "dynamodb_write_capacity_critical_threshold" {
  description = "Critical threshold for DynamoDB consumed write capacity (%)"
  type        = number
  default     = 80
}

variable "dynamodb_write_capacity_warning_threshold" {
  description = "Warning threshold for DynamoDB consumed write capacity (%)"
  type        = number
  default     = 70
}

# DynamoDB Latency thresholds (milliseconds)
variable "dynamodb_latency_critical_threshold" {
  description = "Critical threshold for DynamoDB request latency (ms)"
  type        = number
  default     = 100
}

variable "dynamodb_latency_warning_threshold" {
  description = "Warning threshold for DynamoDB request latency (ms)"
  type        = number
  default     = 50
}