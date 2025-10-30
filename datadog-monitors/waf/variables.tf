variable "waf_blocked_requests_critical_threshold" {
  description = "Critical threshold for WAF blocked requests rate (%)"
  type        = number
  default     = 50
}

variable "waf_blocked_requests_warning_threshold" {
  description = "Warning threshold for WAF blocked requests rate (%)"
  type        = number
  default     = 30
}