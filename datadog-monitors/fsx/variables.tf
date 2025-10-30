variable "fsx_storage_critical_threshold" {
  description = "Critical threshold for FSx storage utilization (%)"
  type        = number
  default     = 90
}

variable "fsx_storage_warning_threshold" {
  description = "Warning threshold for FSx storage utilization (%)"
  type        = number
  default     = 80
}