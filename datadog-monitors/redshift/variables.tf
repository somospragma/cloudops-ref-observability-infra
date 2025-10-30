variable "redshift_cpu_critical_threshold" {
  description = "Critical threshold for Redshift CPU utilization (%)"
  type        = number
  default     = 90
}

variable "redshift_cpu_warning_threshold" {
  description = "Warning threshold for Redshift CPU utilization (%)"
  type        = number
  default     = 80
}

variable "redshift_connections_critical_threshold" {
  description = "Critical threshold for Redshift database connections (count)"
  type        = number
  default     = 400 # 80% of typical 500 limit
}

variable "redshift_connections_warning_threshold" {
  description = "Warning threshold for Redshift database connections (count)"
  type        = number
  default     = 350 # 70% of typical 500 limit
}

variable "redshift_disk_space_critical_threshold" {
  description = "Critical threshold for Redshift disk space usage (%)"
  type        = number
  default     = 90
}

variable "redshift_disk_space_warning_threshold" {
  description = "Warning threshold for Redshift disk space usage (%)"
  type        = number
  default     = 80
}

variable "redshift_read_latency_critical_threshold" {
  description = "Critical threshold for Redshift read latency (ms)"
  type        = number
  default     = 1000
}

variable "redshift_read_latency_warning_threshold" {
  description = "Warning threshold for Redshift read latency (ms)"
  type        = number
  default     = 500
}

variable "redshift_write_latency_critical_threshold" {
  description = "Critical threshold for Redshift write latency (ms)"
  type        = number
  default     = 1000
}

variable "redshift_write_latency_warning_threshold" {
  description = "Warning threshold for Redshift write latency (ms)"
  type        = number
  default     = 500
}