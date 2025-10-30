# EC2 CPU Utilization - Critical
resource "datadog_monitor" "ec2_cpu_critical" {
  name    = "[${var.environment}] EC2 CPU Utilization Critical"
  type    = "metric alert"
  message = "${var.default_message} ${join(" ", var.critical_notification_channels)}"

  query = "avg(last_5m):avg:aws.ec2.cpuutilization{environment:${var.environment}} by {host} > ${var.cpu_critical_threshold}"

  monitor_thresholds {
    critical = var.cpu_critical_threshold
    warning  = var.cpu_warning_threshold
  }

  notify_no_data    = true
  no_data_timeframe = 10
  renotify_interval = 60

  tags = concat(var.tags, ["service:ec2", "severity:critical", "metric:cpu"])
}

# EC2 CPU Utilization - Warning
resource "datadog_monitor" "ec2_cpu_warning" {
  name    = "[${var.environment}] EC2 CPU Utilization Warning"
  type    = "metric alert"
  message = "${var.default_message} ${join(" ", var.warning_notification_channels)}"

  query = "avg(last_5m):avg:aws.ec2.cpuutilization{environment:${var.environment}} by {host} > ${var.cpu_warning_threshold}"

  monitor_thresholds {
    warning = var.cpu_warning_threshold
  }

  notify_no_data    = false
  renotify_interval = 120

  tags = concat(var.tags, ["service:ec2", "severity:warning", "metric:cpu"])
}

# EC2 Status Check Failed
resource "datadog_monitor" "ec2_status_check_failed" {
  name    = "[${var.environment}] EC2 Status Check Failed"
  type    = "metric alert"
  message = "${var.default_message} ${join(" ", var.critical_notification_channels)}"

  query = "avg(last_5m):avg:aws.ec2.status_check_failed{environment:${var.environment}} by {host} > 0"

  monitor_thresholds {
    critical = 0
  }

  notify_no_data    = true
  no_data_timeframe = 10
  renotify_interval = 30

  tags = concat(var.tags, ["service:ec2", "severity:critical", "metric:status_check"])
}

# EC2 Status Check Failed Instance
resource "datadog_monitor" "ec2_status_check_failed_instance" {
  name    = "[${var.environment}] EC2 Instance Status Check Failed"
  type    = "metric alert"
  message = "${var.default_message} ${join(" ", var.critical_notification_channels)}"

  query = "avg(last_5m):avg:aws.ec2.status_check_failed_instance{environment:${var.environment}} by {host} > 0"

  monitor_thresholds {
    critical = 0
  }

  notify_no_data    = true
  no_data_timeframe = 10
  renotify_interval = 30

  tags = concat(var.tags, ["service:ec2", "severity:critical", "metric:status_check_instance"])
}

# EC2 Status Check Failed System
resource "datadog_monitor" "ec2_status_check_failed_system" {
  name    = "[${var.environment}] EC2 System Status Check Failed"
  type    = "metric alert"
  message = "${var.default_message} ${join(" ", var.critical_notification_channels)}"

  query = "avg(last_5m):avg:aws.ec2.status_check_failed_system{environment:${var.environment}} by {host} > 0"

  monitor_thresholds {
    critical = 0
  }

  notify_no_data    = true
  no_data_timeframe = 10
  renotify_interval = 30

  tags = concat(var.tags, ["service:ec2", "severity:critical", "metric:status_check_system"])
}

# EC2 Network In - Performance
resource "datadog_monitor" "ec2_network_in_high" {
  name    = "[${var.environment}] EC2 Network In High"
  type    = "metric alert"
  message = "${var.default_message} ${join(" ", var.warning_notification_channels)}"

  query = "avg(last_15m):avg:aws.ec2.network_in{environment:${var.environment}} by {host} > ${var.network_in_critical_threshold}"

  monitor_thresholds {
    critical = var.network_in_critical_threshold
    warning  = var.network_in_warning_threshold
  }

  notify_no_data    = false
  renotify_interval = 240

  tags = concat(var.tags, ["service:ec2", "severity:warning", "metric:network_in"])
}

# EC2 Network Out - Performance
resource "datadog_monitor" "ec2_network_out_high" {
  name    = "[${var.environment}] EC2 Network Out High"
  type    = "metric alert"
  message = "${var.default_message} ${join(" ", var.warning_notification_channels)}"

  query = "avg(last_15m):avg:aws.ec2.network_out{environment:${var.environment}} by {host} > ${var.network_out_critical_threshold}"

  monitor_thresholds {
    critical = var.network_out_critical_threshold
    warning  = var.network_out_warning_threshold
  }

  notify_no_data    = false
  renotify_interval = 240

  tags = concat(var.tags, ["service:ec2", "severity:warning", "metric:network_out"])
}

# EC2 EBS IO Balance - Capacity
resource "datadog_monitor" "ec2_ebs_io_balance_low" {
  name    = "[${var.environment}] EC2 EBS IO Balance Low"
  type    = "metric alert"
  message = "${var.default_message} ${join(" ", var.critical_notification_channels)}"

  query = "avg(last_10m):avg:aws.ec2.ebs_io_balance{environment:${var.environment}} by {host} < ${var.ebs_io_balance_critical_threshold}"

  monitor_thresholds {
    critical = var.ebs_io_balance_critical_threshold
    warning  = var.ebs_io_balance_warning_threshold
  }

  notify_no_data    = false
  renotify_interval = 120

  tags = concat(var.tags, ["service:ec2", "severity:critical", "metric:ebs_io_balance"])
}

# EC2 EBS Byte Balance - Capacity
resource "datadog_monitor" "ec2_ebs_byte_balance_low" {
  name    = "[${var.environment}] EC2 EBS Byte Balance Low"
  type    = "metric alert"
  message = "${var.default_message} ${join(" ", var.critical_notification_channels)}"

  query = "avg(last_10m):avg:aws.ec2.ebs_byte_balance{environment:${var.environment}} by {host} < ${var.ebs_byte_balance_critical_threshold}"

  monitor_thresholds {
    critical = var.ebs_byte_balance_critical_threshold
    warning  = var.ebs_byte_balance_warning_threshold
  }

  notify_no_data    = false
  renotify_interval = 120

  tags = concat(var.tags, ["service:ec2", "severity:critical", "metric:ebs_byte_balance"])
}