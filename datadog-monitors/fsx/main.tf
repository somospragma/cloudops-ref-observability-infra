# FSx Data Read Bytes - Performance
resource "datadog_monitor" "fsx_data_read_bytes_anomaly" {
  name    = "[FSx] Data Read Bytes Anomaly - {{file_system_id.name}}"
  type    = "metric alert"
  message = "FSx {{file_system_id.name}} data read bytes are anomalous: {{value}} bytes ${var.notification_channels}"

  query = "avg(last_15m):anomalies(avg:aws.fsx.data_read_bytes{${var.filter_tags}} by {file_system_id}, 'basic', 2, direction='both', alert_window='last_15m', interval=60, count_default_zero='true') >= 1"

  monitor_thresholds {
    critical          = 1
    critical_recovery = 0
  }

  notify_no_data    = false
  no_data_timeframe = 20

  tags = concat(var.base_tags, ["service:fsx", "severity:info", "metric:data_read"])
}

# FSx Data Write Bytes - Performance
resource "datadog_monitor" "fsx_data_write_bytes_anomaly" {
  name    = "[FSx] Data Write Bytes Anomaly - {{file_system_id.name}}"
  type    = "metric alert"
  message = "FSx {{file_system_id.name}} data write bytes are anomalous: {{value}} bytes ${var.notification_channels}"

  query = "avg(last_15m):anomalies(avg:aws.fsx.data_write_bytes{${var.filter_tags}} by {file_system_id}, 'basic', 2, direction='both', alert_window='last_15m', interval=60, count_default_zero='true') >= 1"

  monitor_thresholds {
    critical          = 1
    critical_recovery = 0
  }

  notify_no_data    = false
  no_data_timeframe = 20

  tags = concat(var.base_tags, ["service:fsx", "severity:info", "metric:data_write"])
}

# FSx Storage Capacity - Capacity
resource "datadog_monitor" "fsx_storage_capacity_warning" {
  name    = "[FSx] Storage Capacity High - {{file_system_id.name}}"
  type    = "metric alert"
  message = "FSx {{file_system_id.name}} storage capacity utilization is high: {{value}}% ${var.notification_channels}"

  query = "avg(last_5m):avg:aws.fsx.storage_utilization{${var.filter_tags}} by {file_system_id} > ${var.fsx_storage_critical_threshold}"

  monitor_thresholds {
    critical = var.fsx_storage_critical_threshold
    warning  = var.fsx_storage_warning_threshold
  }

  notify_no_data    = false
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:fsx", "severity:warning", "metric:storage_capacity"])
}

# FSx Metadata Operations - Performance
resource "datadog_monitor" "fsx_metadata_operations_anomaly" {
  name    = "[FSx] Metadata Operations Anomaly - {{file_system_id.name}}"
  type    = "metric alert"
  message = "FSx {{file_system_id.name}} metadata operations are anomalous: {{value}} ops ${var.notification_channels}"

  query = "avg(last_15m):anomalies(avg:aws.fsx.metadata_operations{${var.filter_tags}} by {file_system_id}, 'basic', 2, direction='both', alert_window='last_15m', interval=60, count_default_zero='true') >= 1"

  monitor_thresholds {
    critical          = 1
    critical_recovery = 0
  }

  notify_no_data    = false
  no_data_timeframe = 20

  tags = concat(var.base_tags, ["service:fsx", "severity:info", "metric:metadata_ops"])
}