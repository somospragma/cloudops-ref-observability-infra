# DynamoDB Throttled Requests - Critical
resource "datadog_monitor" "dynamodb_throttled_requests_critical" {
  name    = "[DynamoDB] Throttled Requests Critical - {{tablename.name}}"
  type    = "metric alert"
  message = "DynamoDB table {{tablename.name}} has throttled requests: {{value}} ${var.notification_channels}"

  query = "avg(last_5m):sum:aws.dynamodb.throttled_requests{${var.filter_tags}} by {tablename} > ${var.dynamodb_throttled_requests_threshold}"

  monitor_thresholds {
    critical = var.dynamodb_throttled_requests_threshold
  }

  notify_no_data    = false
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:dynamodb", "severity:critical", "metric:throttled_requests"])
}

# DynamoDB System Errors - Critical
resource "datadog_monitor" "dynamodb_system_errors_critical" {
  name    = "[DynamoDB] System Errors Critical - {{tablename.name}}"
  type    = "metric alert"
  message = "DynamoDB table {{tablename.name}} has system errors: {{value}} ${var.notification_channels}"

  query = "avg(last_5m):sum:aws.dynamodb.system_errors{${var.filter_tags}} by {tablename} > ${var.dynamodb_system_errors_threshold}"

  monitor_thresholds {
    critical = var.dynamodb_system_errors_threshold
  }

  notify_no_data    = false
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:dynamodb", "severity:critical", "metric:system_errors"])
}

# DynamoDB User Errors - Critical
resource "datadog_monitor" "dynamodb_user_errors_critical" {
  name    = "[DynamoDB] User Errors Critical - {{tablename.name}}"
  type    = "metric alert"
  message = "DynamoDB table {{tablename.name}} user error rate is high: {{value}}% ${var.notification_channels}"

  query = "avg(last_5m):( sum:aws.dynamodb.user_errors{${var.filter_tags}} by {tablename} / ( sum:aws.dynamodb.successful_request_latency{${var.filter_tags}} by {tablename} + sum:aws.dynamodb.user_errors{${var.filter_tags}} by {tablename} ) ) * 100 > ${var.dynamodb_user_error_rate_critical_threshold}"

  monitor_thresholds {
    critical = var.dynamodb_user_error_rate_critical_threshold
    warning  = var.dynamodb_user_error_rate_warning_threshold
  }

  notify_no_data    = false
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:dynamodb", "severity:critical", "metric:user_errors"])
}

# DynamoDB Consumed Read Capacity - Performance
resource "datadog_monitor" "dynamodb_consumed_read_capacity_warning" {
  name    = "[DynamoDB] Consumed Read Capacity High - {{tablename.name}}"
  type    = "metric alert"
  message = "DynamoDB table {{tablename.name}} consumed read capacity is high: {{value}}% ${var.notification_channels}"

  query = "avg(last_5m):( avg:aws.dynamodb.consumed_read_capacity_units{${var.filter_tags}} by {tablename} / avg:aws.dynamodb.provisioned_read_capacity_units{${var.filter_tags}} by {tablename} ) * 100 > ${var.dynamodb_read_capacity_critical_threshold}"

  monitor_thresholds {
    critical = var.dynamodb_read_capacity_critical_threshold
    warning  = var.dynamodb_read_capacity_warning_threshold
  }

  notify_no_data    = false
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:dynamodb", "severity:warning", "metric:read_capacity"])
}

# DynamoDB Consumed Write Capacity - Performance
resource "datadog_monitor" "dynamodb_consumed_write_capacity_warning" {
  name    = "[DynamoDB] Consumed Write Capacity High - {{tablename.name}}"
  type    = "metric alert"
  message = "DynamoDB table {{tablename.name}} consumed write capacity is high: {{value}}% ${var.notification_channels}"

  query = "avg(last_5m):( avg:aws.dynamodb.consumed_write_capacity_units{${var.filter_tags}} by {tablename} / avg:aws.dynamodb.provisioned_write_capacity_units{${var.filter_tags}} by {tablename} ) * 100 > ${var.dynamodb_write_capacity_critical_threshold}"

  monitor_thresholds {
    critical = var.dynamodb_write_capacity_critical_threshold
    warning  = var.dynamodb_write_capacity_warning_threshold
  }

  notify_no_data    = false
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:dynamodb", "severity:warning", "metric:write_capacity"])
}

# DynamoDB Successful Request Latency - Performance
resource "datadog_monitor" "dynamodb_latency_warning" {
  name    = "[DynamoDB] Request Latency High - {{tablename.name}}"
  type    = "metric alert"
  message = "DynamoDB table {{tablename.name}} request latency is high: {{value}}ms ${var.notification_channels}"

  query = "avg(last_5m):avg:aws.dynamodb.successful_request_latency{${var.filter_tags}} by {tablename} > ${var.dynamodb_latency_critical_threshold}"

  monitor_thresholds {
    critical = var.dynamodb_latency_critical_threshold
    warning  = var.dynamodb_latency_warning_threshold
  }

  notify_no_data    = false
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:dynamodb", "severity:warning", "metric:latency"])
}