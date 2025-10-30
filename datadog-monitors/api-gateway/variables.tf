# API Gateway 4xx Error Rate thresholds (%)
variable "api_gateway_4xx_error_rate_critical_threshold" {
  description = "Critical threshold for API Gateway 4xx error rate (%)"
  type        = number
  default     = 5
}

variable "api_gateway_4xx_error_rate_warning_threshold" {
  description = "Warning threshold for API Gateway 4xx error rate (%)"
  type        = number
  default     = 2
}

# API Gateway 5xx Error Rate thresholds (%)
variable "api_gateway_5xx_error_rate_critical_threshold" {
  description = "Critical threshold for API Gateway 5xx error rate (%)"
  type        = number
  default     = 1
}

variable "api_gateway_5xx_error_rate_warning_threshold" {
  description = "Warning threshold for API Gateway 5xx error rate (%)"
  type        = number
  default     = 0.5
}

# API Gateway Integration Latency thresholds (milliseconds)
variable "api_gateway_integration_latency_critical_threshold" {
  description = "Critical threshold for API Gateway integration latency (ms)"
  type        = number
  default     = 29000
}

variable "api_gateway_integration_latency_warning_threshold" {
  description = "Warning threshold for API Gateway integration latency (ms)"
  type        = number
  default     = 10000
}

# API Gateway Total Latency thresholds (milliseconds)
variable "api_gateway_latency_critical_threshold" {
  description = "Critical threshold for API Gateway total latency (ms)"
  type        = number
  default     = 29000
}

variable "api_gateway_latency_warning_threshold" {
  description = "Warning threshold for API Gateway total latency (ms)"
  type        = number
  default     = 10000
}