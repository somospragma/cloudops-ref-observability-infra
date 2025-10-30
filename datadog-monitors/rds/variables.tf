# RDS CPU Utilization thresholds
variable "rds_cpu_critical_threshold" {
  description = "Critical threshold for RDS CPU utilization (%)"
  type        = number
  default     = 90
}

variable "rds_cpu_warning_threshold" {
  description = "Warning threshold for RDS CPU utilization (%)"
  type        = number
  default     = 80
}

# RDS Database Connections thresholds
variable "rds_connections_critical_threshold" {
  description = "Critical threshold for RDS database connections (count)"
  type        = number
  default     = 80
}

variable "rds_connections_warning_threshold" {
  description = "Warning threshold for RDS database connections (count)"
  type        = number
  default     = 70
}

# RDS Freeable Memory thresholds (bytes)
variable "rds_memory_critical_threshold" {
  description = "Critical threshold for RDS freeable memory (bytes)"
  type        = number
  default     = 104857600 # 100MB
}

variable "rds_memory_warning_threshold" {
  description = "Warning threshold for RDS freeable memory (bytes)"
  type        = number
  default     = 524288000 # 500MB
}

# RDS Free Storage Space thresholds (bytes)
variable "rds_storage_critical_threshold" {
  description = "Critical threshold for RDS free storage space (bytes)"
  type        = number
  default     = 2147483648 # 2GB
}

variable "rds_storage_warning_threshold" {
  description = "Warning threshold for RDS free storage space (bytes)"
  type        = number
  default     = 5368709120 # 5GB
}

# RDS Read Latency thresholds (seconds)
variable "rds_read_latency_critical_threshold" {
  description = "Critical threshold for RDS read latency (seconds)"
  type        = number
  default     = 0.2
}

variable "rds_read_latency_warning_threshold" {
  description = "Warning threshold for RDS read latency (seconds)"
  type        = number
  default     = 0.1
}

# RDS Write Latency thresholds (seconds)
variable "rds_write_latency_critical_threshold" {
  description = "Critical threshold for RDS write latency (seconds)"
  type        = number
  default     = 0.2
}

variable "rds_write_latency_warning_threshold" {
  description = "Warning threshold for RDS write latency (seconds)"
  type        = number
  default     = 0.1
}

# RDS Replica Lag thresholds (seconds)
variable "rds_replica_lag_critical_threshold" {
  description = "Critical threshold for RDS replica lag (seconds)"
  type        = number
  default     = 300
}

variable "rds_replica_lag_warning_threshold" {
  description = "Warning threshold for RDS replica lag (seconds)"
  type        = number
  default     = 60
}

# RDS Swap Usage thresholds (bytes)
variable "rds_swap_critical_threshold" {
  description = "Critical threshold for RDS swap usage (bytes)"
  type        = number
  default     = 268435456 # 256MB
}

variable "rds_swap_warning_threshold" {
  description = "Warning threshold for RDS swap usage (bytes)"
  type        = number
  default     = 134217728 # 128MB
}