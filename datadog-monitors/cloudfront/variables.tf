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

# CloudFront Error Rate Thresholds (%)
variable "error_4xx_critical_threshold" {
  description = "Critical threshold for 4xx error rate (%)"
  type        = number
  default     = 5
}

variable "error_4xx_warning_threshold" {
  description = "Warning threshold for 4xx error rate (%)"
  type        = number
  default     = 2
}

variable "error_5xx_critical_threshold" {
  description = "Critical threshold for 5xx error rate (%)"
  type        = number
  default     = 1
}

variable "error_5xx_warning_threshold" {
  description = "Warning threshold for 5xx error rate (%)"
  type        = number
  default     = 0.5
}

# CloudFront Origin Latency Thresholds (ms)
variable "origin_latency_critical_threshold" {
  description = "Critical threshold for origin latency (ms)"
  type        = number
  default     = 30000
}

variable "origin_latency_warning_threshold" {
  description = "Warning threshold for origin latency (ms)"
  type        = number
  default     = 10000
}

# CloudFront Requests Thresholds (adjust based on baseline)
variable "requests_critical_threshold" {
  description = "Critical threshold for requests count"
  type        = number
  default     = 10000 # adjust based on baseline + 500%
}

variable "requests_warning_threshold" {
  description = "Warning threshold for requests count"
  type        = number
  default     = 7500 # adjust based on baseline + 300%
}

# CloudFront Cache Hit Rate Thresholds (%)
variable "cache_hit_rate_critical_threshold" {
  description = "Critical threshold for cache hit rate (%)"
  type        = number
  default     = 80
}

variable "cache_hit_rate_warning_threshold" {
  description = "Warning threshold for cache hit rate (%)"
  type        = number
  default     = 85
}

# CloudFront Bytes Thresholds (bytes)
variable "bytes_downloaded_critical_threshold" {
  description = "Critical threshold for bytes downloaded"
  type        = number
  default     = 10000000000 # 10GB - adjust based on baseline
}

variable "bytes_downloaded_warning_threshold" {
  description = "Warning threshold for bytes downloaded"
  type        = number
  default     = 7500000000 # 7.5GB - adjust based on baseline
}

variable "bytes_uploaded_critical_threshold" {
  description = "Critical threshold for bytes uploaded"
  type        = number
  default     = 1000000000 # 1GB - adjust based on baseline
}

variable "bytes_uploaded_warning_threshold" {
  description = "Warning threshold for bytes uploaded"
  type        = number
  default     = 750000000 # 750MB - adjust based on baseline
}
