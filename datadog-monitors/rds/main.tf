# RDS CPU Utilization - Critical
resource "datadog_monitor" "rds_cpu_utilization_critical" {
  name    = "[RDS] CPU Utilization Critical - {{db_instance_identifier.name}}"
  type    = "metric alert"
  message = "RDS instance {{db_instance_identifier.name}} CPU utilization is critically high: {{value}}% ${var.notification_channels}"

  query = "avg(last_5m):avg:aws.rds.cpuutilization{${var.filter_tags}} by {db_instance_identifier} > ${var.rds_cpu_critical_threshold}"

  monitor_thresholds {
    critical = var.rds_cpu_critical_threshold
    warning  = var.rds_cpu_warning_threshold
  }

  notify_no_data      = true
  no_data_timeframe   = 10
  require_full_window = false

  tags = concat(var.base_tags, ["service:rds", "severity:critical", "metric:cpu"])
}

# RDS Database Connections - Critical
resource "datadog_monitor" "rds_database_connections_critical" {
  name    = "[RDS] Database Connections Critical - {{db_instance_identifier.name}}"
  type    = "metric alert"
  message = "RDS instance {{db_instance_identifier.name}} has too many database connections: {{value}} ${var.notification_channels}"

  query = "avg(last_5m):avg:aws.rds.database_connections{${var.filter_tags}} by {db_instance_identifier} > ${var.rds_connections_critical_threshold}"

  monitor_thresholds {
    critical = var.rds_connections_critical_threshold
    warning  = var.rds_connections_warning_threshold
  }

  notify_no_data    = true
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:rds", "severity:critical", "metric:connections"])
}

# RDS Freeable Memory - Critical
resource "datadog_monitor" "rds_freeable_memory_critical" {
  name    = "[RDS] Freeable Memory Critical - {{db_instance_identifier.name}}"
  type    = "metric alert"
  message = "RDS instance {{db_instance_identifier.name}} has critically low freeable memory: {{value}} bytes ${var.notification_channels}"

  query = "avg(last_5m):avg:aws.rds.freeable_memory{${var.filter_tags}} by {db_instance_identifier} < ${var.rds_memory_critical_threshold}"

  monitor_thresholds {
    critical = var.rds_memory_critical_threshold
    warning  = var.rds_memory_warning_threshold
  }

  notify_no_data    = true
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:rds", "severity:critical", "metric:memory"])
}

# RDS Free Storage Space - Critical
resource "datadog_monitor" "rds_free_storage_space_critical" {
  name    = "[RDS] Free Storage Space Critical - {{db_instance_identifier.name}}"
  type    = "metric alert"
  message = "RDS instance {{db_instance_identifier.name}} has critically low free storage space: {{value}} bytes ${var.notification_channels}"

  query = "avg(last_5m):avg:aws.rds.free_storage_space{${var.filter_tags}} by {db_instance_identifier} < ${var.rds_storage_critical_threshold}"

  monitor_thresholds {
    critical = var.rds_storage_critical_threshold
    warning  = var.rds_storage_warning_threshold
  }

  notify_no_data    = true
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:rds", "severity:critical", "metric:storage"])
}

# RDS Read Latency - Performance
resource "datadog_monitor" "rds_read_latency_warning" {
  name    = "[RDS] Read Latency High - {{db_instance_identifier.name}}"
  type    = "metric alert"
  message = "RDS instance {{db_instance_identifier.name}} read latency is high: {{value}}s ${var.notification_channels}"

  query = "avg(last_5m):avg:aws.rds.read_latency{${var.filter_tags}} by {db_instance_identifier} > ${var.rds_read_latency_critical_threshold}"

  monitor_thresholds {
    critical = var.rds_read_latency_critical_threshold
    warning  = var.rds_read_latency_warning_threshold
  }

  notify_no_data    = true
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:rds", "severity:warning", "metric:latency"])
}

# RDS Write Latency - Performance
resource "datadog_monitor" "rds_write_latency_warning" {
  name    = "[RDS] Write Latency High - {{db_instance_identifier.name}}"
  type    = "metric alert"
  message = "RDS instance {{db_instance_identifier.name}} write latency is high: {{value}}s ${var.notification_channels}"

  query = "avg(last_5m):avg:aws.rds.write_latency{${var.filter_tags}} by {db_instance_identifier} > ${var.rds_write_latency_critical_threshold}"

  monitor_thresholds {
    critical = var.rds_write_latency_critical_threshold
    warning  = var.rds_write_latency_warning_threshold
  }

  notify_no_data    = true
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:rds", "severity:warning", "metric:latency"])
}

# RDS Replica Lag - Replication
resource "datadog_monitor" "rds_replica_lag_critical" {
  name    = "[RDS] Replica Lag Critical - {{db_instance_identifier.name}}"
  type    = "metric alert"
  message = "RDS replica {{db_instance_identifier.name}} lag is critically high: {{value}}s ${var.notification_channels}"

  query = "avg(last_5m):avg:aws.rds.replica_lag{${var.filter_tags}} by {db_instance_identifier} > ${var.rds_replica_lag_critical_threshold}"

  monitor_thresholds {
    critical = var.rds_replica_lag_critical_threshold
    warning  = var.rds_replica_lag_warning_threshold
  }

  notify_no_data    = false
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:rds", "severity:critical", "metric:replication"])
}

# RDS Swap Usage - Performance
resource "datadog_monitor" "rds_swap_usage_warning" {
  name    = "[RDS] Swap Usage High - {{db_instance_identifier.name}}"
  type    = "metric alert"
  message = "RDS instance {{db_instance_identifier.name}} swap usage is high: {{value}} bytes ${var.notification_channels}"

  query = "avg(last_5m):avg:aws.rds.swap_usage{${var.filter_tags}} by {db_instance_identifier} > ${var.rds_swap_critical_threshold}"

  monitor_thresholds {
    critical = var.rds_swap_critical_threshold
    warning  = var.rds_swap_warning_threshold
  }

  notify_no_data    = false
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:rds", "severity:warning", "metric:swap"])
}