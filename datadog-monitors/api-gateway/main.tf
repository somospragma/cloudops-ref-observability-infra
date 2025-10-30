# API Gateway 4xx Errors - Critical
resource "datadog_monitor" "api_gateway_4xx_errors_critical" {
  name    = "[API Gateway] 4xx Errors Critical - {{apiname.name}}"
  type    = "metric alert"
  message = "API Gateway {{apiname.name}} 4xx error rate is critically high: {{value}}% ${var.notification_channels}"

  query = "avg(last_5m):( sum:aws.apigateway.4xxerror{${var.filter_tags}} by {apiname} / sum:aws.apigateway.count{${var.filter_tags}} by {apiname} ) * 100 > ${var.api_gateway_4xx_error_rate_critical_threshold}"

  monitor_thresholds {
    critical = var.api_gateway_4xx_error_rate_critical_threshold
    warning  = var.api_gateway_4xx_error_rate_warning_threshold
  }

  notify_no_data    = false
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:api-gateway", "severity:critical", "metric:4xx_errors"])
}

# API Gateway 5xx Errors - Critical
resource "datadog_monitor" "api_gateway_5xx_errors_critical" {
  name    = "[API Gateway] 5xx Errors Critical - {{apiname.name}}"
  type    = "metric alert"
  message = "API Gateway {{apiname.name}} 5xx error rate is critically high: {{value}}% ${var.notification_channels}"

  query = "avg(last_5m):( sum:aws.apigateway.5xxerror{${var.filter_tags}} by {apiname} / sum:aws.apigateway.count{${var.filter_tags}} by {apiname} ) * 100 > ${var.api_gateway_5xx_error_rate_critical_threshold}"

  monitor_thresholds {
    critical = var.api_gateway_5xx_error_rate_critical_threshold
    warning  = var.api_gateway_5xx_error_rate_warning_threshold
  }

  notify_no_data    = false
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:api-gateway", "severity:critical", "metric:5xx_errors"])
}

# API Gateway Integration Latency - Critical
resource "datadog_monitor" "api_gateway_integration_latency_critical" {
  name    = "[API Gateway] Integration Latency Critical - {{apiname.name}}"
  type    = "metric alert"
  message = "API Gateway {{apiname.name}} integration latency is critically high: {{value}}ms ${var.notification_channels}"

  query = "avg(last_5m):avg:aws.apigateway.integration_latency{${var.filter_tags}} by {apiname} > ${var.api_gateway_integration_latency_critical_threshold}"

  monitor_thresholds {
    critical = var.api_gateway_integration_latency_critical_threshold
    warning  = var.api_gateway_integration_latency_warning_threshold
  }

  notify_no_data    = false
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:api-gateway", "severity:critical", "metric:integration_latency"])
}

# API Gateway Total Latency - Critical
resource "datadog_monitor" "api_gateway_latency_critical" {
  name    = "[API Gateway] Latency Critical - {{apiname.name}}"
  type    = "metric alert"
  message = "API Gateway {{apiname.name}} total latency is critically high: {{value}}ms ${var.notification_channels}"

  query = "avg(last_5m):avg:aws.apigateway.latency{${var.filter_tags}} by {apiname} > ${var.api_gateway_latency_critical_threshold}"

  monitor_thresholds {
    critical = var.api_gateway_latency_critical_threshold
    warning  = var.api_gateway_latency_warning_threshold
  }

  notify_no_data    = false
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:api-gateway", "severity:critical", "metric:latency"])
}

# API Gateway Request Count - Performance Monitoring
resource "datadog_monitor" "api_gateway_count_anomaly" {
  name    = "[API Gateway] Request Count Anomaly - {{apiname.name}}"
  type    = "metric alert"
  message = "API Gateway {{apiname.name}} request count is anomalous: {{value}} requests ${var.notification_channels}"

  query = "avg(last_15m):anomalies(sum:aws.apigateway.count{${var.filter_tags}} by {apiname}, 'basic', 2, direction='both', alert_window='last_15m', interval=60, count_default_zero='true') >= 1"

  monitor_thresholds {
    critical          = 1
    critical_recovery = 0
  }

  notify_no_data    = false
  no_data_timeframe = 20

  tags = concat(var.base_tags, ["service:api-gateway", "severity:info", "metric:count"])
}

# API Gateway Cache Hit Count - Performance Monitoring
resource "datadog_monitor" "api_gateway_cache_hit_anomaly" {
  name    = "[API Gateway] Cache Hit Anomaly - {{apiname.name}}"
  type    = "metric alert"
  message = "API Gateway {{apiname.name}} cache hit count is anomalous: {{value}} hits ${var.notification_channels}"

  query = "avg(last_15m):anomalies(sum:aws.apigateway.cache_hit_count{${var.filter_tags}} by {apiname}, 'basic', 2, direction='both', alert_window='last_15m', interval=60, count_default_zero='true') >= 1"

  monitor_thresholds {
    critical          = 1
    critical_recovery = 0
  }

  notify_no_data    = false
  no_data_timeframe = 20

  tags = concat(var.base_tags, ["service:api-gateway", "severity:info", "metric:cache_hits"])
}