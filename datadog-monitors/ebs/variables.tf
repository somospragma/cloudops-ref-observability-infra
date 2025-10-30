variable "ebs_queue_length_critical_threshold" {
  description = "Critical threshold for EBS volume queue length"
  type        = number
  default     = 32
}

variable "ebs_queue_length_warning_threshold" {
  description = "Warning threshold for EBS volume queue length"
  type        = number
  default     = 16
}

variable "ebs_throughput_critical_threshold" {
  description = "Critical threshold for EBS throughput percentage (%)"
  type        = number
  default     = 90
}

variable "ebs_throughput_warning_threshold" {
  description = "Warning threshold for EBS throughput percentage (%)"
  type        = number
  default     = 80
}

variable "ebs_burst_balance_critical_threshold" {
  description = "Critical threshold for EBS burst balance (%)"
  type        = number
  default     = 10
}

variable "ebs_burst_balance_warning_threshold" {
  description = "Warning threshold for EBS burst balance (%)"
  type        = number
  default     = 20
}