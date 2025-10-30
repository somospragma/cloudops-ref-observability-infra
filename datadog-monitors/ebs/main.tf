# EBS Volume Queue Length - Critical
resource "datadog_monitor" "ebs_volume_queue_length_critical" {
  name    = "[EBS] Volume Queue Length Critical - {{volume_id.name}}"
  type    = "metric alert"
  message = "EBS volume {{volume_id.name}} queue length is critically high: {{value}} ${var.notification_channels}"

  query = "avg(last_5m):avg:aws.ebs.volume_queue_length{${var.filter_tags}} by {volume_id} > ${var.ebs_queue_length_critical_threshold}"

  monitor_thresholds {
    critical = var.ebs_queue_length_critical_threshold
    warning  = var.ebs_queue_length_warning_threshold
  }

  notify_no_data    = false
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:ebs", "severity:critical", "metric:queue_length"])
}

# EBS Volume Throughput Percentage - Critical
resource "datadog_monitor" "ebs_throughput_percentage_critical" {
  name    = "[EBS] Throughput Percentage Critical - {{volume_id.name}}"
  type    = "metric alert"
  message = "EBS volume {{volume_id.name}} throughput percentage is critically high: {{value}}% ${var.notification_channels}"

  query = "avg(last_5m):avg:aws.ebs.volume_throughput_percentage{${var.filter_tags}} by {volume_id} > ${var.ebs_throughput_critical_threshold}"

  monitor_thresholds {
    critical = var.ebs_throughput_critical_threshold
    warning  = var.ebs_throughput_warning_threshold
  }

  notify_no_data    = false
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:ebs", "severity:critical", "metric:throughput"])
}

# EBS Burst Balance - Critical
resource "datadog_monitor" "ebs_burst_balance_critical" {
  name    = "[EBS] Burst Balance Critical - {{volume_id.name}}"
  type    = "metric alert"
  message = "EBS volume {{volume_id.name}} burst balance is critically low: {{value}}% ${var.notification_channels}"

  query = "avg(last_5m):avg:aws.ebs.burst_balance{${var.filter_tags}} by {volume_id} < ${var.ebs_burst_balance_critical_threshold}"

  monitor_thresholds {
    critical = var.ebs_burst_balance_critical_threshold
    warning  = var.ebs_burst_balance_warning_threshold
  }

  notify_no_data    = false
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:ebs", "severity:critical", "metric:burst_balance"])
}

# EBS Volume Read Ops - Performance
resource "datadog_monitor" "ebs_volume_read_ops_anomaly" {
  name    = "[EBS] Volume Read Ops Anomaly - {{volume_id.name}}"
  type    = "metric alert"
  message = "EBS volume {{volume_id.name}} read operations are anomalous: {{value}} ops ${var.notification_channels}"

  query = "avg(last_15m):anomalies(avg:aws.ebs.volume_read_ops{${var.filter_tags}} by {volume_id}, 'basic', 2, direction='both', alert_window='last_15m', interval=60, count_default_zero='true') >= 1"

  monitor_thresholds {
    critical          = 1
    critical_recovery = 0
  }

  notify_no_data    = false
  no_data_timeframe = 20

  tags = concat(var.base_tags, ["service:ebs", "severity:info", "metric:read_ops"])
}

# EBS Volume Write Ops - Performance
resource "datadog_monitor" "ebs_volume_write_ops_anomaly" {
  name    = "[EBS] Volume Write Ops Anomaly - {{volume_id.name}}"
  type    = "metric alert"
  message = "EBS volume {{volume_id.name}} write operations are anomalous: {{value}} ops ${var.notification_channels}"

  query = "avg(last_15m):anomalies(avg:aws.ebs.volume_write_ops{${var.filter_tags}} by {volume_id}, 'basic', 2, direction='both', alert_window='last_15m', interval=60, count_default_zero='true') >= 1"

  monitor_thresholds {
    critical          = 1
    critical_recovery = 0
  }

  notify_no_data    = false
  no_data_timeframe = 20

  tags = concat(var.base_tags, ["service:ebs", "severity:info", "metric:write_ops"])
}