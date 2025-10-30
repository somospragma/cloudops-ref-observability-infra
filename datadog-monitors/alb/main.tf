# ALB ELB 5XX Errors - Critical
resource "datadog_monitor" "alb_elb_5xx_errors_critical" {
  name    = "[${var.environment}] ALB ELB 5XX Errors Critical"
  type    = "metric alert"
  message = "${var.default_message} ${join(" ", var.critical_notification_channels)}"

  query = "avg(last_5m):avg:aws.applicationelb.httpcode_elb_5xx_count{environment:${var.environment}} by {loadbalancer} > ${var.elb_5xx_errors_critical_threshold}"

  monitor_thresholds {
    critical = var.elb_5xx_errors_critical_threshold
    warning  = var.elb_5xx_errors_warning_threshold
  }

  notify_no_data    = true
  no_data_timeframe = 10
  renotify_interval = 60

  tags = concat(var.tags, ["service:alb", "severity:critical", "metric:elb_5xx_errors"])
}

# ALB Target 5XX Errors - Critical
resource "datadog_monitor" "alb_target_5xx_errors_critical" {
  name    = "[${var.environment}] ALB Target 5XX Errors Critical"
  type    = "metric alert"
  message = "${var.default_message} ${join(" ", var.critical_notification_channels)}"

  query = "avg(last_5m):avg:aws.applicationelb.httpcode_target_5xx_count{environment:${var.environment}} by {loadbalancer} > ${var.target_5xx_errors_critical_threshold}"

  monitor_thresholds {
    critical = var.target_5xx_errors_critical_threshold
    warning  = var.target_5xx_errors_warning_threshold
  }

  notify_no_data    = true
  no_data_timeframe = 10
  renotify_interval = 60

  tags = concat(var.tags, ["service:alb", "severity:critical", "metric:target_5xx_errors"])
}

# ALB Unhealthy Hosts - Critical
resource "datadog_monitor" "alb_unhealthy_hosts_critical" {
  name    = "[${var.environment}] ALB Unhealthy Hosts Critical"
  type    = "metric alert"
  message = "${var.default_message} ${join(" ", var.critical_notification_channels)}"

  query = "avg(last_5m):avg:aws.applicationelb.un_healthy_host_count{environment:${var.environment}} by {loadbalancer} > ${var.unhealthy_hosts_critical_threshold}"

  monitor_thresholds {
    critical = var.unhealthy_hosts_critical_threshold
  }

  notify_no_data    = true
  no_data_timeframe = 10
  renotify_interval = 60

  tags = concat(var.tags, ["service:alb", "severity:critical", "metric:unhealthy_hosts"])
}

# ALB Target Response Time - Critical
resource "datadog_monitor" "alb_target_response_time_critical" {
  name    = "[${var.environment}] ALB Target Response Time Critical"
  type    = "metric alert"
  message = "${var.default_message} ${join(" ", var.critical_notification_channels)}"

  query = "avg(last_5m):avg:aws.applicationelb.target_response_time{environment:${var.environment}} by {loadbalancer} > ${var.target_response_time_critical_threshold}"

  monitor_thresholds {
    critical = var.target_response_time_critical_threshold
    warning  = var.target_response_time_warning_threshold
  }

  notify_no_data    = true
  no_data_timeframe = 10
  renotify_interval = 60

  tags = concat(var.tags, ["service:alb", "severity:critical", "metric:target_response_time"])
}

# ALB Request Count - Warning
resource "datadog_monitor" "alb_request_count_warning" {
  name    = "[${var.environment}] ALB Request Count High"
  type    = "metric alert"
  message = "${var.default_message} ${join(" ", var.warning_notification_channels)}"

  query = "avg(last_15m):avg:aws.applicationelb.request_count{environment:${var.environment}} by {loadbalancer} > ${var.request_count_critical_threshold}"

  monitor_thresholds {
    critical = var.request_count_critical_threshold
    warning  = var.request_count_warning_threshold
  }

  notify_no_data    = false
  renotify_interval = 240

  tags = concat(var.tags, ["service:alb", "severity:warning", "metric:request_count"])
}