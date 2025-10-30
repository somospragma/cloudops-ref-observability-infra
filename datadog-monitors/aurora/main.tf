# Aurora CPU Utilization - Critical
resource "datadog_monitor" "aurora_cpu_utilization_critical" {
  name    = "[Aurora] CPU Utilization Critical - {{db_instance_identifier.name}}"
  type    = "metric alert"
  message = "Aurora instance {{db_instance_identifier.name}} CPU utilization is critically high: {{value}}% ${var.notification_channels}"

  query = "avg(last_5m):avg:aws.rds.cpuutilization{${var.filter_tags},engine:aurora} by {db_instance_identifier} > ${var.aurora_cpu_critical_threshold}"

  monitor_thresholds {
    critical = var.aurora_cpu_critical_threshold
    warning  = var.aurora_cpu_warning_threshold
  }

  notify_no_data    = true
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:aurora", "severity:critical", "metric:cpu"])
}

# Aurora Database Connections - Critical
resource "datadog_monitor" "aurora_database_connections_critical" {
  name    = "[Aurora] Database Connections Critical - {{db_instance_identifier.name}}"
  type    = "metric alert"
  message = "Aurora instance {{db_instance_identifier.name}} has too many database connections: {{value}} ${var.notification_channels}"

  query = "avg(last_5m):avg:aws.rds.database_connections{${var.filter_tags},engine:aurora} by {db_instance_identifier} > ${var.aurora_connections_critical_threshold}"

  monitor_thresholds {
    critical = var.aurora_connections_critical_threshold
    warning  = var.aurora_connections_warning_threshold
  }

  notify_no_data    = true
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:aurora", "severity:critical", "metric:connections"])
}

# Aurora Freeable Memory - Critical
resource "datadog_monitor" "aurora_freeable_memory_critical" {
  name    = "[Aurora] Freeable Memory Critical - {{db_instance_identifier.name}}"
  type    = "metric alert"
  message = "Aurora instance {{db_instance_identifier.name}} has critically low freeable memory: {{value}} bytes ${var.notification_channels}"

  query = "avg(last_5m):avg:aws.rds.freeable_memory{${var.filter_tags},engine:aurora} by {db_instance_identifier} < ${var.aurora_memory_critical_threshold}"

  monitor_thresholds {
    critical = var.aurora_memory_critical_threshold
    warning  = var.aurora_memory_warning_threshold
  }

  notify_no_data    = true
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:aurora", "severity:critical", "metric:memory"])
}

# Aurora Replica Lag - Critical
resource "datadog_monitor" "aurora_replica_lag_critical" {
  name    = "[Aurora] Replica Lag Critical - {{db_instance_identifier.name}}"
  type    = "metric alert"
  message = "Aurora replica {{db_instance_identifier.name}} lag is critically high: {{value}}ms ${var.notification_channels}"

  query = "avg(last_5m):avg:aws.rds.aurora_replica_lag{${var.filter_tags}} by {db_instance_identifier} > ${var.aurora_replica_lag_critical_threshold}"

  monitor_thresholds {
    critical = var.aurora_replica_lag_critical_threshold
    warning  = var.aurora_replica_lag_warning_threshold
  }

  notify_no_data    = false
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:aurora", "severity:critical", "metric:replica_lag"])
}

# Aurora Select Latency - Performance
resource "datadog_monitor" "aurora_select_latency_warning" {
  name    = "[Aurora] Select Latency High - {{db_instance_identifier.name}}"
  type    = "metric alert"
  message = "Aurora instance {{db_instance_identifier.name}} SELECT latency is high: {{value}}ms ${var.notification_channels}"

  query = "avg(last_5m):avg:aws.rds.select_latency{${var.filter_tags},engine:aurora} by {db_instance_identifier} > ${var.aurora_select_latency_critical_threshold}"

  monitor_thresholds {
    critical = var.aurora_select_latency_critical_threshold
    warning  = var.aurora_select_latency_warning_threshold
  }

  notify_no_data    = false
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:aurora", "severity:warning", "metric:select_latency"])
}

# Aurora Insert Latency - Performance
resource "datadog_monitor" "aurora_insert_latency_warning" {
  name    = "[Aurora] Insert Latency High - {{db_instance_identifier.name}}"
  type    = "metric alert"
  message = "Aurora instance {{db_instance_identifier.name}} INSERT latency is high: {{value}}ms ${var.notification_channels}"

  query = "avg(last_5m):avg:aws.rds.insert_latency{${var.filter_tags},engine:aurora} by {db_instance_identifier} > ${var.aurora_insert_latency_critical_threshold}"

  monitor_thresholds {
    critical = var.aurora_insert_latency_critical_threshold
    warning  = var.aurora_insert_latency_warning_threshold
  }

  notify_no_data    = false
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:aurora", "severity:warning", "metric:insert_latency"])
}

# Aurora Commit Latency - Performance
resource "datadog_monitor" "aurora_commit_latency_warning" {
  name    = "[Aurora] Commit Latency High - {{db_instance_identifier.name}}"
  type    = "metric alert"
  message = "Aurora instance {{db_instance_identifier.name}} COMMIT latency is high: {{value}}ms ${var.notification_channels}"

  query = "avg(last_5m):avg:aws.rds.commit_latency{${var.filter_tags},engine:aurora} by {db_instance_identifier} > ${var.aurora_commit_latency_critical_threshold}"

  monitor_thresholds {
    critical = var.aurora_commit_latency_critical_threshold
    warning  = var.aurora_commit_latency_warning_threshold
  }

  notify_no_data    = false
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:aurora", "severity:warning", "metric:commit_latency"])
}