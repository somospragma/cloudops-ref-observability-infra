variable "efs_io_limit_critical_threshold" {
  description = "Critical threshold for EFS percent IO limit (%)"
  type        = number
  default     = 80
}

variable "efs_io_limit_warning_threshold" {
  description = "Warning threshold for EFS percent IO limit (%)"
  type        = number
  default     = 70
}

variable "efs_burst_credit_critical_threshold" {
  description = "Critical threshold for EFS burst credit balance (bytes)"
  type        = number
  default     = 1073741824 # 1GB
}

variable "efs_burst_credit_warning_threshold" {
  description = "Warning threshold for EFS burst credit balance (bytes)"
  type        = number
  default     = 5368709120 # 5GB
}

variable "efs_client_connections_critical_threshold" {
  description = "Critical threshold for EFS client connections"
  type        = number
  default     = 1000
}

variable "efs_client_connections_warning_threshold" {
  description = "Warning threshold for EFS client connections"
  type        = number
  default     = 500
}