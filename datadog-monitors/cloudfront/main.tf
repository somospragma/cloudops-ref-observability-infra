# CloudFront 4xx Error Rate - Critical
resource "datadog_monitor" "cloudfront_4xx_error_critical" {
  name    = "[${var.environment}] CloudFront 4xx Error Rate Critical"
  type    = "metric alert"
  message = "${var.default_message} ${join(" ", var.critical_notification_channels)}"

  query = "avg(last_5m):avg:aws.cloudfront.4xx_error_rate{environment:${var.environment}} by {distributionid} > ${var.error_4xx_critical_threshold}"

  monitor_thresholds {
    critical = var.error_4xx_critical_threshold
    warning  = var.error_4xx_warning_threshold
  }

  notify_no_data    = true
  no_data_timeframe = 10
  renotify_interval = 60

  tags = concat(var.tags, ["service:cloudfront", "severity:critical", "metric:4xx_error_rate"])
}

# CloudFront 5xx Error Rate - Critical
resource "datadog_monitor" "cloudfront_5xx_error_critical" {
  name    = "[${var.environment}] CloudFront 5xx Error Rate Critical"
  type    = "metric alert"
  message = "${var.default_message} ${join(" ", var.critical_notification_channels)}"

  query = "avg(last_5m):avg:aws.cloudfront.5xx_error_rate{environment:${var.environment}} by {distributionid} > ${var.error_5xx_critical_threshold}"

  monitor_thresholds {
    critical = var.error_5xx_critical_threshold
    warning  = var.error_5xx_warning_threshold
  }

  notify_no_data    = true
  no_data_timeframe = 10
  renotify_interval = 60

  tags = concat(var.tags, ["service:cloudfront", "severity:critical", "metric:5xx_error_rate"])
}

# CloudFront Origin Latency - Critical
resource "datadog_monitor" "cloudfront_origin_latency_critical" {
  name    = "[${var.environment}] CloudFront Origin Latency Critical"
  type    = "metric alert"
  message = "${var.default_message} ${join(" ", var.critical_notification_channels)}"

  query = "avg(last_5m):avg:aws.cloudfront.origin_latency{environment:${var.environment}} by {distributionid} > ${var.origin_latency_critical_threshold}"

  monitor_thresholds {
    critical = var.origin_latency_critical_threshold
    warning  = var.origin_latency_warning_threshold
  }

  notify_no_data    = true
  no_data_timeframe = 10
  renotify_interval = 60

  tags = concat(var.tags, ["service:cloudfront", "severity:critical", "metric:origin_latency"])
}

# CloudFront Requests - Performance
resource "datadog_monitor" "cloudfront_requests_high" {
  name    = "[${var.environment}] CloudFront Requests High"
  type    = "metric alert"
  message = "${var.default_message} ${join(" ", var.warning_notification_channels)}"

  query = "avg(last_15m):avg:aws.cloudfront.requests{environment:${var.environment}} by {distributionid} > ${var.requests_critical_threshold}"

  monitor_thresholds {
    critical = var.requests_critical_threshold
    warning  = var.requests_warning_threshold
  }

  notify_no_data    = false
  renotify_interval = 240

  tags = concat(var.tags, ["service:cloudfront", "severity:warning", "metric:requests"])
}

# CloudFront Cache Hit Rate - Performance
resource "datadog_monitor" "cloudfront_cache_hit_rate_low" {
  name    = "[${var.environment}] CloudFront Cache Hit Rate Low"
  type    = "metric alert"
  message = "${var.default_message} ${join(" ", var.warning_notification_channels)}"

  query = "avg(last_15m):avg:aws.cloudfront.cache_hit_rate{environment:${var.environment}} by {distributionid} < ${var.cache_hit_rate_critical_threshold}"

  monitor_thresholds {
    critical = var.cache_hit_rate_critical_threshold
    warning  = var.cache_hit_rate_warning_threshold
  }

  notify_no_data    = false
  renotify_interval = 240

  tags = concat(var.tags, ["service:cloudfront", "severity:warning", "metric:cache_hit_rate"])
}

# CloudFront Bytes Downloaded - Performance
resource "datadog_monitor" "cloudfront_bytes_downloaded_high" {
  name    = "[${var.environment}] CloudFront Bytes Downloaded High"
  type    = "metric alert"
  message = "${var.default_message} ${join(" ", var.warning_notification_channels)}"

  query = "avg(last_15m):avg:aws.cloudfront.bytes_downloaded{environment:${var.environment}} by {distributionid} > ${var.bytes_downloaded_critical_threshold}"

  monitor_thresholds {
    critical = var.bytes_downloaded_critical_threshold
    warning  = var.bytes_downloaded_warning_threshold
  }

  notify_no_data    = false
  renotify_interval = 240

  tags = concat(var.tags, ["service:cloudfront", "severity:warning", "metric:bytes_downloaded"])
}

# CloudFront Bytes Uploaded - Performance
resource "datadog_monitor" "cloudfront_bytes_uploaded_high" {
  name    = "[${var.environment}] CloudFront Bytes Uploaded High"
  type    = "metric alert"
  message = "${var.default_message} ${join(" ", var.warning_notification_channels)}"

  query = "avg(last_15m):avg:aws.cloudfront.bytes_uploaded{environment:${var.environment}} by {distributionid} > ${var.bytes_uploaded_critical_threshold}"

  monitor_thresholds {
    critical = var.bytes_uploaded_critical_threshold
    warning  = var.bytes_uploaded_warning_threshold
  }

  notify_no_data    = false
  renotify_interval = 240

  tags = concat(var.tags, ["service:cloudfront", "severity:warning", "metric:bytes_uploaded"])
}