# ElastiCache CPU Utilization thresholds
variable "elasticache_cpu_critical_threshold" {
  description = "Critical threshold for ElastiCache CPU utilization (%)"
  type        = number
  default     = 90
}

variable "elasticache_cpu_warning_threshold" {
  description = "Warning threshold for ElastiCache CPU utilization (%)"
  type        = number
  default     = 80
}

# ElastiCache Swap Usage thresholds (bytes)
variable "elasticache_swap_critical_threshold" {
  description = "Critical threshold for ElastiCache swap usage (bytes)"
  type        = number
  default     = 52428800 # 50MB
}

variable "elasticache_swap_warning_threshold" {
  description = "Warning threshold for ElastiCache swap usage (bytes)"
  type        = number
  default     = 26214400 # 25MB
}

# ElastiCache Evictions thresholds (per minute)
variable "elasticache_evictions_critical_threshold" {
  description = "Critical threshold for ElastiCache evictions (per minute)"
  type        = number
  default     = 100
}

variable "elasticache_evictions_warning_threshold" {
  description = "Warning threshold for ElastiCache evictions (per minute)"
  type        = number
  default     = 50
}

# ElastiCache Cache Hit Rate thresholds (%)
variable "elasticache_hit_rate_critical_threshold" {
  description = "Critical threshold for ElastiCache cache hit rate (%)"
  type        = number
  default     = 80
}

variable "elasticache_hit_rate_warning_threshold" {
  description = "Warning threshold for ElastiCache cache hit rate (%)"
  type        = number
  default     = 85
}

# ElastiCache Current Connections thresholds
variable "elasticache_connections_critical_threshold" {
  description = "Critical threshold for ElastiCache current connections (count)"
  type        = number
  default     = 800 # 80% of typical 1000 limit
}

variable "elasticache_connections_warning_threshold" {
  description = "Warning threshold for ElastiCache current connections (count)"
  type        = number
  default     = 700 # 70% of typical 1000 limit
}

# ElastiCache Memory Usage thresholds (%)
variable "elasticache_memory_critical_threshold" {
  description = "Critical threshold for ElastiCache memory usage (%)"
  type        = number
  default     = 90
}

variable "elasticache_memory_warning_threshold" {
  description = "Warning threshold for ElastiCache memory usage (%)"
  type        = number
  default     = 80
}

# ElastiCache Replication Lag thresholds (seconds)
variable "elasticache_replication_lag_critical_threshold" {
  description = "Critical threshold for ElastiCache replication lag (seconds)"
  type        = number
  default     = 5
}

variable "elasticache_replication_lag_warning_threshold" {
  description = "Warning threshold for ElastiCache replication lag (seconds)"
  type        = number
  default     = 2
}