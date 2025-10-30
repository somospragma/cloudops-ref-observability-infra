# S3 4xx Errors - Critical
resource "datadog_monitor" "s3_4xx_errors_critical" {
  name    = "[S3] 4xx Errors Critical - {{bucketname.name}}"
  type    = "metric alert"
  message = "S3 bucket {{bucketname.name}} 4xx error rate is critically high: {{value}}% ${var.notification_channels}"

  query = "avg(last_5m):( sum:aws.s3.4xx_errors{${var.filter_tags}} by {bucketname} / sum:aws.s3.all_requests{${var.filter_tags}} by {bucketname} ) * 100 > ${var.s3_4xx_error_rate_critical_threshold}"

  monitor_thresholds {
    critical = var.s3_4xx_error_rate_critical_threshold
    warning  = var.s3_4xx_error_rate_warning_threshold
  }

  notify_no_data      = false
  no_data_timeframe   = 10
  require_full_window = false

  tags = concat(var.base_tags, ["service:s3", "severity:critical", "metric:4xx_errors"])
}

# S3 5xx Errors - Critical
resource "datadog_monitor" "s3_5xx_errors_critical" {
  name    = "[S3] 5xx Errors Critical - {{bucketname.name}}"
  type    = "metric alert"
  message = "S3 bucket {{bucketname.name}} 5xx error rate is critically high: {{value}}% ${var.notification_channels}"

  query = "avg(last_5m):( sum:aws.s3.5xx_errors{${var.filter_tags}} by {bucketname} / sum:aws.s3.all_requests{${var.filter_tags}} by {bucketname} ) * 100 > ${var.s3_5xx_error_rate_critical_threshold}"

  monitor_thresholds {
    critical = var.s3_5xx_error_rate_critical_threshold
    warning  = var.s3_5xx_error_rate_warning_threshold
  }

  notify_no_data      = false
  no_data_timeframe   = 10
  require_full_window = false

  tags = concat(var.base_tags, ["service:s3", "severity:critical", "metric:5xx_errors"])
}

# S3 All Requests Errors - Critical
resource "datadog_monitor" "s3_all_requests_errors_critical" {
  name    = "[S3] All Requests Errors Critical - {{bucketname.name}}"
  type    = "metric alert"
  message = "S3 bucket {{bucketname.name}} total error rate is critically high: {{value}}% ${var.notification_channels}"

  query = "avg(last_5m):( ( sum:aws.s3.4xx_errors{${var.filter_tags}} by {bucketname} + sum:aws.s3.5xx_errors{${var.filter_tags}} by {bucketname} ) / sum:aws.s3.all_requests{${var.filter_tags}} by {bucketname} ) * 100 > ${var.s3_all_errors_critical_threshold}"

  monitor_thresholds {
    critical = var.s3_all_errors_critical_threshold
    warning  = var.s3_all_errors_warning_threshold
  }

  notify_no_data    = false
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:s3", "severity:critical", "metric:all_errors"])
}

# S3 First Byte Latency - Performance
resource "datadog_monitor" "s3_first_byte_latency_warning" {
  name    = "[S3] First Byte Latency High - {{bucketname.name}}"
  type    = "metric alert"
  message = "S3 bucket {{bucketname.name}} first byte latency is high: {{value}}ms ${var.notification_channels}"

  query = "avg(last_5m):avg:aws.s3.first_byte_latency{${var.filter_tags}} by {bucketname} > ${var.s3_first_byte_latency_critical_threshold}"

  monitor_thresholds {
    critical = var.s3_first_byte_latency_critical_threshold
    warning  = var.s3_first_byte_latency_warning_threshold
  }

  notify_no_data    = false
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:s3", "severity:warning", "metric:first_byte_latency"])
}

# S3 Total Request Latency - Performance
resource "datadog_monitor" "s3_total_request_latency_warning" {
  name    = "[S3] Total Request Latency High - {{bucketname.name}}"
  type    = "metric alert"
  message = "S3 bucket {{bucketname.name}} total request latency is high: {{value}}ms ${var.notification_channels}"

  query = "avg(last_5m):avg:aws.s3.total_request_latency{${var.filter_tags}} by {bucketname} > ${var.s3_total_latency_critical_threshold}"

  monitor_thresholds {
    critical = var.s3_total_latency_critical_threshold
    warning  = var.s3_total_latency_warning_threshold
  }

  notify_no_data    = false
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:s3", "severity:warning", "metric:total_latency"])
}

# S3 All Requests - Performance Monitoring
resource "datadog_monitor" "s3_all_requests_anomaly" {
  name    = "[S3] All Requests Anomaly - {{bucketname.name}}"
  type    = "metric alert"
  message = "S3 bucket {{bucketname.name}} request volume is anomalous: {{value}} requests ${var.notification_channels}"

  query = "avg(last_15m):anomalies(sum:aws.s3.all_requests{${var.filter_tags}} by {bucketname}, 'basic', 2, direction='both', alert_window='last_15m', interval=60, count_default_zero='true') >= 1"

  monitor_thresholds {
    critical          = 1
    critical_recovery = 0
  }

  notify_no_data    = false
  no_data_timeframe = 20

  tags = concat(var.base_tags, ["service:s3", "severity:info", "metric:requests"])
}

# S3 GET Requests - Performance Monitoring
resource "datadog_monitor" "s3_get_requests_anomaly" {
  name    = "[S3] GET Requests Anomaly - {{bucketname.name}}"
  type    = "metric alert"
  message = "S3 bucket {{bucketname.name}} GET request volume is anomalous: {{value}} requests ${var.notification_channels}"

  query = "avg(last_15m):anomalies(sum:aws.s3.get_requests{${var.filter_tags}} by {bucketname}, 'basic', 2, direction='both', alert_window='last_15m', interval=60, count_default_zero='true') >= 1"

  monitor_thresholds {
    critical          = 1
    critical_recovery = 0
  }

  notify_no_data    = false
  no_data_timeframe = 20

  tags = concat(var.base_tags, ["service:s3", "severity:info", "metric:get_requests"])
}

# S3 PUT Requests - Performance Monitoring
resource "datadog_monitor" "s3_put_requests_anomaly" {
  name    = "[S3] PUT Requests Anomaly - {{bucketname.name}}"
  type    = "metric alert"
  message = "S3 bucket {{bucketname.name}} PUT request volume is anomalous: {{value}} requests ${var.notification_channels}"

  query = "avg(last_15m):anomalies(sum:aws.s3.put_requests{${var.filter_tags}} by {bucketname}, 'basic', 2, direction='both', alert_window='last_15m', interval=60, count_default_zero='true') >= 1"

  monitor_thresholds {
    critical          = 1
    critical_recovery = 0
  }

  notify_no_data    = false
  no_data_timeframe = 20

  tags = concat(var.base_tags, ["service:s3", "severity:info", "metric:put_requests"])
}