# ElastiCache CPU Utilization - Critical
resource "datadog_monitor" "elasticache_cpu_utilization_critical" {
  name    = "[ElastiCache] CPU Utilization Critical - {{cache_cluster_id.name}}"
  type    = "metric alert"
  message = "ElastiCache cluster {{cache_cluster_id.name}} CPU utilization is critically high: {{value}}% ${var.notification_channels}"

  query = "avg(last_5m):avg:aws.elasticache.cpuutilization{${var.filter_tags}} by {cache_cluster_id} > ${var.elasticache_cpu_critical_threshold}"

  monitor_thresholds {
    critical = var.elasticache_cpu_critical_threshold
    warning  = var.elasticache_cpu_warning_threshold
  }

  notify_no_data    = true
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:elasticache", "severity:critical", "metric:cpu"])
}

# ElastiCache Swap Usage - Critical
resource "datadog_monitor" "elasticache_swap_usage_critical" {
  name    = "[ElastiCache] Swap Usage Critical - {{cache_cluster_id.name}}"
  type    = "metric alert"
  message = "ElastiCache cluster {{cache_cluster_id.name}} swap usage is critically high: {{value}} bytes ${var.notification_channels}"

  query = "avg(last_5m):avg:aws.elasticache.swap_usage{${var.filter_tags}} by {cache_cluster_id} > ${var.elasticache_swap_critical_threshold}"

  monitor_thresholds {
    critical = var.elasticache_swap_critical_threshold
    warning  = var.elasticache_swap_warning_threshold
  }

  notify_no_data    = false
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:elasticache", "severity:critical", "metric:swap"])
}

# ElastiCache Evictions - Critical
resource "datadog_monitor" "elasticache_evictions_critical" {
  name    = "[ElastiCache] Evictions Critical - {{cache_cluster_id.name}}"
  type    = "metric alert"
  message = "ElastiCache cluster {{cache_cluster_id.name}} evictions are high: {{value}}/min ${var.notification_channels}"

  query = "avg(last_5m):per_minute(avg:aws.elasticache.evictions{${var.filter_tags}} by {cache_cluster_id}) > ${var.elasticache_evictions_critical_threshold}"

  monitor_thresholds {
    critical = var.elasticache_evictions_critical_threshold
    warning  = var.elasticache_evictions_warning_threshold
  }

  notify_no_data    = false
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:elasticache", "severity:critical", "metric:evictions"])
}

# ElastiCache Cache Hit Rate - Performance
resource "datadog_monitor" "elasticache_cache_hit_rate_warning" {
  name    = "[ElastiCache] Cache Hit Rate Low - {{cache_cluster_id.name}}"
  type    = "metric alert"
  message = "ElastiCache cluster {{cache_cluster_id.name}} cache hit rate is low: {{value}}% ${var.notification_channels}"

  query = "avg(last_5m):( avg:aws.elasticache.cache_hits{${var.filter_tags}} by {cache_cluster_id} / ( avg:aws.elasticache.cache_hits{${var.filter_tags}} by {cache_cluster_id} + avg:aws.elasticache.cache_misses{${var.filter_tags}} by {cache_cluster_id} ) ) * 100 < ${var.elasticache_hit_rate_critical_threshold}"

  monitor_thresholds {
    critical = var.elasticache_hit_rate_critical_threshold
    warning  = var.elasticache_hit_rate_warning_threshold
  }

  notify_no_data    = false
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:elasticache", "severity:warning", "metric:hit_rate"])
}

# ElastiCache Current Connections - Performance
resource "datadog_monitor" "elasticache_current_connections_warning" {
  name    = "[ElastiCache] Current Connections High - {{cache_cluster_id.name}}"
  type    = "metric alert"
  message = "ElastiCache cluster {{cache_cluster_id.name}} current connections are high: {{value}} ${var.notification_channels}"

  query = "avg(last_5m):avg:aws.elasticache.curr_connections{${var.filter_tags}} by {cache_cluster_id} > ${var.elasticache_connections_critical_threshold}"

  monitor_thresholds {
    critical = var.elasticache_connections_critical_threshold
    warning  = var.elasticache_connections_warning_threshold
  }

  notify_no_data    = false
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:elasticache", "severity:warning", "metric:connections"])
}

# ElastiCache Database Memory Usage - Capacity
resource "datadog_monitor" "elasticache_memory_usage_warning" {
  name    = "[ElastiCache] Memory Usage High - {{cache_cluster_id.name}}"
  type    = "metric alert"
  message = "ElastiCache cluster {{cache_cluster_id.name}} memory usage is high: {{value}}% ${var.notification_channels}"

  query = "avg(last_5m):avg:aws.elasticache.database_memory_usage_percentage{${var.filter_tags}} by {cache_cluster_id} > ${var.elasticache_memory_critical_threshold}"

  monitor_thresholds {
    critical = var.elasticache_memory_critical_threshold
    warning  = var.elasticache_memory_warning_threshold
  }

  notify_no_data    = false
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:elasticache", "severity:warning", "metric:memory_usage"])
}

# ElastiCache Replication Lag - Critical (Redis only)
resource "datadog_monitor" "elasticache_replication_lag_critical" {
  name    = "[ElastiCache] Replication Lag Critical - {{cache_cluster_id.name}}"
  type    = "metric alert"
  message = "ElastiCache Redis cluster {{cache_cluster_id.name}} replication lag is high: {{value}}s ${var.notification_channels}"

  query = "avg(last_5m):avg:aws.elasticache.replication_lag{${var.filter_tags}} by {cache_cluster_id} > ${var.elasticache_replication_lag_critical_threshold}"

  monitor_thresholds {
    critical = var.elasticache_replication_lag_critical_threshold
    warning  = var.elasticache_replication_lag_warning_threshold
  }

  notify_no_data    = false
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:elasticache", "severity:critical", "metric:replication_lag"])
}