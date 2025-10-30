# S3 4xx Error Rate thresholds (%)
variable "s3_4xx_error_rate_critical_threshold" {
  description = "Critical threshold for S3 4xx error rate (%)"
  type        = number
  default     = 5
}

variable "s3_4xx_error_rate_warning_threshold" {
  description = "Warning threshold for S3 4xx error rate (%)"
  type        = number
  default     = 2
}

# S3 5xx Error Rate thresholds (%)
variable "s3_5xx_error_rate_critical_threshold" {
  description = "Critical threshold for S3 5xx error rate (%)"
  type        = number
  default     = 1
}

variable "s3_5xx_error_rate_warning_threshold" {
  description = "Warning threshold for S3 5xx error rate (%)"
  type        = number
  default     = 0.5
}

# S3 All Requests Error Rate thresholds (%)
variable "s3_all_errors_critical_threshold" {
  description = "Critical threshold for S3 all requests error rate (%)"
  type        = number
  default     = 5
}

variable "s3_all_errors_warning_threshold" {
  description = "Warning threshold for S3 all requests error rate (%)"
  type        = number
  default     = 2
}

# S3 First Byte Latency thresholds (milliseconds)
variable "s3_first_byte_latency_critical_threshold" {
  description = "Critical threshold for S3 first byte latency (ms)"
  type        = number
  default     = 1000
}

variable "s3_first_byte_latency_warning_threshold" {
  description = "Warning threshold for S3 first byte latency (ms)"
  type        = number
  default     = 500
}

# S3 Total Request Latency thresholds (milliseconds)
variable "s3_total_latency_critical_threshold" {
  description = "Critical threshold for S3 total request latency (ms)"
  type        = number
  default     = 5000
}

variable "s3_total_latency_warning_threshold" {
  description = "Warning threshold for S3 total request latency (ms)"
  type        = number
  default     = 2000
}