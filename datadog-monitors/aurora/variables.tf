# Aurora CPU Utilization thresholds
variable "aurora_cpu_critical_threshold" {
  description = "Critical threshold for Aurora CPU utilization (%)"
  type        = number
  default     = 90
}

variable "aurora_cpu_warning_threshold" {
  description = "Warning threshold for Aurora CPU utilization (%)"
  type        = number
  default     = 80
}

# Aurora Database Connections thresholds
variable "aurora_connections_critical_threshold" {
  description = "Critical threshold for Aurora database connections (count)"
  type        = number
  default     = 80
}

variable "aurora_connections_warning_threshold" {
  description = "Warning threshold for Aurora database connections (count)"
  type        = number
  default     = 70
}

# Aurora Freeable Memory thresholds (bytes)
variable "aurora_memory_critical_threshold" {
  description = "Critical threshold for Aurora freeable memory (bytes)"
  type        = number
  default     = 104857600 # 100MB
}

variable "aurora_memory_warning_threshold" {
  description = "Warning threshold for Aurora freeable memory (bytes)"
  type        = number
  default     = 524288000 # 500MB
}

# Aurora Replica Lag thresholds (milliseconds)
variable "aurora_replica_lag_critical_threshold" {
  description = "Critical threshold for Aurora replica lag (ms)"
  type        = number
  default     = 1000
}

variable "aurora_replica_lag_warning_threshold" {
  description = "Warning threshold for Aurora replica lag (ms)"
  type        = number
  default     = 500
}

# Aurora Select Latency thresholds (milliseconds)
variable "aurora_select_latency_critical_threshold" {
  description = "Critical threshold for Aurora SELECT latency (ms)"
  type        = number
  default     = 100
}

variable "aurora_select_latency_warning_threshold" {
  description = "Warning threshold for Aurora SELECT latency (ms)"
  type        = number
  default     = 50
}

# Aurora Insert Latency thresholds (milliseconds)
variable "aurora_insert_latency_critical_threshold" {
  description = "Critical threshold for Aurora INSERT latency (ms)"
  type        = number
  default     = 100
}

variable "aurora_insert_latency_warning_threshold" {
  description = "Warning threshold for Aurora INSERT latency (ms)"
  type        = number
  default     = 50
}

# Aurora Commit Latency thresholds (milliseconds)
variable "aurora_commit_latency_critical_threshold" {
  description = "Critical threshold for Aurora COMMIT latency (ms)"
  type        = number
  default     = 100
}

variable "aurora_commit_latency_warning_threshold" {
  description = "Warning threshold for Aurora COMMIT latency (ms)"
  type        = number
  default     = 50
}