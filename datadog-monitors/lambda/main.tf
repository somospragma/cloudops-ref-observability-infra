# Lambda Errors - Critical
resource "datadog_monitor" "lambda_errors_critical" {
  name    = "[Lambda] Errors Critical - {{functionname.name}}"
  type    = "metric alert"
  message = "Lambda function {{functionname.name}} error rate is critically high: {{value}}% ${var.notification_channels}"

  query = "avg(last_5m):( sum:aws.lambda.errors{${var.filter_tags}} by {functionname} / sum:aws.lambda.invocations{${var.filter_tags}} by {functionname} ) * 100 > ${var.lambda_error_rate_critical_threshold}"

  monitor_thresholds {
    critical = var.lambda_error_rate_critical_threshold
    warning  = var.lambda_error_rate_warning_threshold
  }

  notify_no_data      = true
  no_data_timeframe   = 10
  require_full_window = false

  tags = concat(var.base_tags, ["service:lambda", "severity:critical", "metric:errors"])
}

# Lambda Throttles - Critical
resource "datadog_monitor" "lambda_throttles_critical" {
  name    = "[Lambda] Throttles Critical - {{functionname.name}}"
  type    = "metric alert"
  message = "Lambda function {{functionname.name}} is being throttled: {{value}} throttles ${var.notification_channels}"

  query = "avg(last_5m):sum:aws.lambda.throttles{${var.filter_tags}} by {functionname} > ${var.lambda_throttles_critical_threshold}"

  monitor_thresholds {
    critical = var.lambda_throttles_critical_threshold
  }

  notify_no_data    = false
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:lambda", "severity:critical", "metric:throttles"])
}

# Lambda Dead Letter Errors - Critical
resource "datadog_monitor" "lambda_dead_letter_errors_critical" {
  name    = "[Lambda] Dead Letter Errors Critical - {{functionname.name}}"
  type    = "metric alert"
  message = "Lambda function {{functionname.name}} has dead letter queue errors: {{value}} errors ${var.notification_channels}"

  query = "avg(last_5m):sum:aws.lambda.dead_letter_errors{${var.filter_tags}} by {functionname} > ${var.lambda_dlq_errors_critical_threshold}"

  monitor_thresholds {
    critical = var.lambda_dlq_errors_critical_threshold
  }

  notify_no_data    = false
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:lambda", "severity:critical", "metric:dlq_errors"])
}

# Lambda Duration - Performance
resource "datadog_monitor" "lambda_duration_warning" {
  name    = "[Lambda] Duration High - {{functionname.name}}"
  type    = "metric alert"
  message = "Lambda function {{functionname.name}} duration is high: {{value}}ms ${var.notification_channels}"

  query = "avg(last_5m):avg:aws.lambda.duration{${var.filter_tags}} by {functionname} > ${var.lambda_duration_critical_threshold}"

  monitor_thresholds {
    critical = var.lambda_duration_critical_threshold
    warning  = var.lambda_duration_warning_threshold
  }

  notify_no_data    = true
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:lambda", "severity:warning", "metric:duration"])
}

# Lambda Concurrent Executions - Capacity
resource "datadog_monitor" "lambda_concurrent_executions_warning" {
  name    = "[Lambda] Concurrent Executions High - {{functionname.name}}"
  type    = "metric alert"
  message = "Lambda function {{functionname.name}} concurrent executions are high: {{value}} ${var.notification_channels}"

  query = "avg(last_5m):avg:aws.lambda.concurrent_executions{${var.filter_tags}} by {functionname} > ${var.lambda_concurrent_critical_threshold}"

  monitor_thresholds {
    critical = var.lambda_concurrent_critical_threshold
    warning  = var.lambda_concurrent_warning_threshold
  }

  notify_no_data    = false
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:lambda", "severity:warning", "metric:concurrency"])
}

# Lambda Iterator Age - Performance (for stream-based invocations)
resource "datadog_monitor" "lambda_iterator_age_warning" {
  name    = "[Lambda] Iterator Age High - {{functionname.name}}"
  type    = "metric alert"
  message = "Lambda function {{functionname.name}} iterator age is high: {{value}}ms ${var.notification_channels}"

  query = "avg(last_5m):avg:aws.lambda.iterator_age{${var.filter_tags}} by {functionname} > ${var.lambda_iterator_age_critical_threshold}"

  monitor_thresholds {
    critical = var.lambda_iterator_age_critical_threshold
    warning  = var.lambda_iterator_age_warning_threshold
  }

  notify_no_data    = false
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:lambda", "severity:warning", "metric:iterator_age"])
}

# Lambda Invocations - Monitoring
resource "datadog_monitor" "lambda_invocations_anomaly" {
  name    = "[Lambda] Invocations Anomaly - {{functionname.name}}"
  type    = "metric alert"
  message = "Lambda function {{functionname.name}} invocations are anomalous: {{value}} invocations ${var.notification_channels}"

  query = "avg(last_15m):anomalies(avg:aws.lambda.invocations{${var.filter_tags}} by {functionname}, 'basic', 2, direction='both', alert_window='last_15m', interval=60, count_default_zero='true') >= 1"

  monitor_thresholds {
    critical          = 1
    critical_recovery = 0
  }

  notify_no_data    = false
  no_data_timeframe = 20

  tags = concat(var.base_tags, ["service:lambda", "severity:info", "metric:invocations"])
}