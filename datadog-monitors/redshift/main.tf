# Redshift CPU Utilization - Critical
resource "datadog_monitor" "redshift_cpu_utilization_critical" {
  name    = "[Redshift] CPU Utilization Critical - {{cluster_identifier.name}}"
  type    = "metric alert"
  message = "Redshift cluster {{cluster_identifier.name}} CPU utilization is critically high: {{value}}% ${var.notification_channels}"

  query = "avg(last_5m):avg:aws.redshift.cpuutilization{${var.filter_tags}} by {cluster_identifier} > ${var.redshift_cpu_critical_threshold}"

  monitor_thresholds {
    critical = var.redshift_cpu_critical_threshold
    warning  = var.redshift_cpu_warning_threshold
  }

  notify_no_data    = true
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:redshift", "severity:critical", "metric:cpu"])
}

# Redshift Database Connections - Critical
resource "datadog_monitor" "redshift_database_connections_critical" {
  name    = "[Redshift] Database Connections Critical - {{cluster_identifier.name}}"
  type    = "metric alert"
  message = "Redshift cluster {{cluster_identifier.name}} database connections are high: {{value}} ${var.notification_channels}"

  query = "avg(last_5m):avg:aws.redshift.database_connections{${var.filter_tags}} by {cluster_identifier} > ${var.redshift_connections_critical_threshold}"

  monitor_thresholds {
    critical = var.redshift_connections_critical_threshold
    warning  = var.redshift_connections_warning_threshold
  }

  notify_no_data    = false
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:redshift", "severity:critical", "metric:connections"])
}

# Redshift Percentage Disk Space Used - Critical
resource "datadog_monitor" "redshift_disk_space_critical" {
  name    = "[Redshift] Disk Space Critical - {{cluster_identifier.name}}"
  type    = "metric alert"
  message = "Redshift cluster {{cluster_identifier.name}} disk space usage is critically high: {{value}}% ${var.notification_channels}"

  query = "avg(last_5m):avg:aws.redshift.percentage_disk_space_used{${var.filter_tags}} by {cluster_identifier} > ${var.redshift_disk_space_critical_threshold}"

  monitor_thresholds {
    critical = var.redshift_disk_space_critical_threshold
    warning  = var.redshift_disk_space_warning_threshold
  }

  notify_no_data    = false
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:redshift", "severity:critical", "metric:disk_space"])
}

# Redshift Read Latency - Performance
resource "datadog_monitor" "redshift_read_latency_warning" {
  name    = "[Redshift] Read Latency High - {{cluster_identifier.name}}"
  type    = "metric alert"
  message = "Redshift cluster {{cluster_identifier.name}} read latency is high: {{value}}ms ${var.notification_channels}"

  query = "avg(last_5m):avg:aws.redshift.read_latency{${var.filter_tags}} by {cluster_identifier} > ${var.redshift_read_latency_critical_threshold}"

  monitor_thresholds {
    critical = var.redshift_read_latency_critical_threshold
    warning  = var.redshift_read_latency_warning_threshold
  }

  notify_no_data    = false
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:redshift", "severity:warning", "metric:read_latency"])
}

# Redshift Write Latency - Performance
resource "datadog_monitor" "redshift_write_latency_warning" {
  name    = "[Redshift] Write Latency High - {{cluster_identifier.name}}"
  type    = "metric alert"
  message = "Redshift cluster {{cluster_identifier.name}} write latency is high: {{value}}ms ${var.notification_channels}"

  query = "avg(last_5m):avg:aws.redshift.write_latency{${var.filter_tags}} by {cluster_identifier} > ${var.redshift_write_latency_critical_threshold}"

  monitor_thresholds {
    critical = var.redshift_write_latency_critical_threshold
    warning  = var.redshift_write_latency_warning_threshold
  }

  notify_no_data    = false
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:redshift", "severity:warning", "metric:write_latency"])
}