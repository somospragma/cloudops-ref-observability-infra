# EFS Percent IO Limit - Critical
resource "datadog_monitor" "efs_percent_io_limit_critical" {
  name    = "[EFS] Percent IO Limit Critical - {{file_system_id.name}}"
  type    = "metric alert"
  message = "EFS {{file_system_id.name}} percent IO limit is critically high: {{value}}% ${var.notification_channels}"

  query = "avg(last_5m):avg:aws.efs.percent_iolimit{${var.filter_tags}} by {file_system_id} > ${var.efs_io_limit_critical_threshold}"

  monitor_thresholds {
    critical = var.efs_io_limit_critical_threshold
    warning  = var.efs_io_limit_warning_threshold
  }

  notify_no_data    = false
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:efs", "severity:critical", "metric:io_limit"])
}

# EFS Burst Credit Balance - Critical
resource "datadog_monitor" "efs_burst_credit_balance_critical" {
  name    = "[EFS] Burst Credit Balance Critical - {{file_system_id.name}}"
  type    = "metric alert"
  message = "EFS {{file_system_id.name}} burst credit balance is critically low: {{value}} bytes ${var.notification_channels}"

  query = "avg(last_5m):avg:aws.efs.burst_credit_balance{${var.filter_tags}} by {file_system_id} < ${var.efs_burst_credit_critical_threshold}"

  monitor_thresholds {
    critical = var.efs_burst_credit_critical_threshold
    warning  = var.efs_burst_credit_warning_threshold
  }

  notify_no_data    = false
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:efs", "severity:critical", "metric:burst_credits"])
}

# EFS Client Connections - Critical
resource "datadog_monitor" "efs_client_connections_critical" {
  name    = "[EFS] Client Connections Critical - {{file_system_id.name}}"
  type    = "metric alert"
  message = "EFS {{file_system_id.name}} client connections are critically high: {{value}} ${var.notification_channels}"

  query = "avg(last_5m):avg:aws.efs.client_connections{${var.filter_tags}} by {file_system_id} > ${var.efs_client_connections_critical_threshold}"

  monitor_thresholds {
    critical = var.efs_client_connections_critical_threshold
    warning  = var.efs_client_connections_warning_threshold
  }

  notify_no_data    = false
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:efs", "severity:critical", "metric:client_connections"])
}

# EFS Total IO Bytes - Performance
resource "datadog_monitor" "efs_total_io_bytes_anomaly" {
  name    = "[EFS] Total IO Bytes Anomaly - {{file_system_id.name}}"
  type    = "metric alert"
  message = "EFS {{file_system_id.name}} total IO bytes are anomalous: {{value}} bytes ${var.notification_channels}"

  query = "avg(last_15m):anomalies(avg:aws.efs.total_io_bytes{${var.filter_tags}} by {file_system_id}, 'basic', 2, direction='both', alert_window='last_15m', interval=60, count_default_zero='true') >= 1"

  monitor_thresholds {
    critical          = 1
    critical_recovery = 0
  }

  notify_no_data    = false
  no_data_timeframe = 20

  tags = concat(var.base_tags, ["service:efs", "severity:info", "metric:total_io"])
}

# EFS Storage Bytes - Capacity
resource "datadog_monitor" "efs_storage_bytes_anomaly" {
  name    = "[EFS] Storage Bytes Anomaly - {{file_system_id.name}}"
  type    = "metric alert"
  message = "EFS {{file_system_id.name}} storage bytes are anomalous: {{value}} bytes ${var.notification_channels}"

  query = "avg(last_15m):anomalies(avg:aws.efs.storage_bytes{${var.filter_tags}} by {file_system_id}, 'basic', 2, direction='both', alert_window='last_15m', interval=60, count_default_zero='true') >= 1"

  monitor_thresholds {
    critical          = 1
    critical_recovery = 0
  }

  notify_no_data    = false
  no_data_timeframe = 20

  tags = concat(var.base_tags, ["service:efs", "severity:info", "metric:storage"])
}