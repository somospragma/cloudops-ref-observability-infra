# WAF Blocked Requests - Critical
resource "datadog_monitor" "waf_blocked_requests_critical" {
  name    = "[WAF] Blocked Requests Critical - {{webacl.name}}"
  type    = "metric alert"
  message = "WAF {{webacl.name}} blocked requests rate is critically high: {{value}}% ${var.notification_channels}"

  query = "avg(last_5m):( sum:aws.wafv2.blocked_requests{${var.filter_tags}} by {webacl} / ( sum:aws.wafv2.blocked_requests{${var.filter_tags}} by {webacl} + sum:aws.wafv2.allowed_requests{${var.filter_tags}} by {webacl} ) ) * 100 > ${var.waf_blocked_requests_critical_threshold}"

  monitor_thresholds {
    critical = var.waf_blocked_requests_critical_threshold
    warning  = var.waf_blocked_requests_warning_threshold
  }

  notify_no_data    = false
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:waf", "severity:critical", "metric:blocked_requests"])
}

# WAF Allowed Requests - Performance Monitoring
resource "datadog_monitor" "waf_allowed_requests_anomaly" {
  name    = "[WAF] Allowed Requests Anomaly - {{webacl.name}}"
  type    = "metric alert"
  message = "WAF {{webacl.name}} allowed requests are anomalous: {{value}} requests ${var.notification_channels}"

  query = "avg(last_15m):anomalies(sum:aws.wafv2.allowed_requests{${var.filter_tags}} by {webacl}, 'basic', 2, direction='both', alert_window='last_15m', interval=60, count_default_zero='true') >= 1"

  monitor_thresholds {
    critical          = 1
    critical_recovery = 0
  }

  notify_no_data    = false
  no_data_timeframe = 20

  tags = concat(var.base_tags, ["service:waf", "severity:info", "metric:allowed_requests"])
}

# WAF Counted Requests - Performance Monitoring
resource "datadog_monitor" "waf_counted_requests_anomaly" {
  name    = "[WAF] Counted Requests Anomaly - {{webacl.name}}"
  type    = "metric alert"
  message = "WAF {{webacl.name}} counted requests are anomalous: {{value}} requests ${var.notification_channels}"

  query = "avg(last_15m):anomalies(sum:aws.wafv2.counted_requests{${var.filter_tags}} by {webacl}, 'basic', 2, direction='both', alert_window='last_15m', interval=60, count_default_zero='true') >= 1"

  monitor_thresholds {
    critical          = 1
    critical_recovery = 0
  }

  notify_no_data    = false
  no_data_timeframe = 20

  tags = concat(var.base_tags, ["service:waf", "severity:info", "metric:counted_requests"])
}

# WAF CAPTCHA Requests - Performance Monitoring
resource "datadog_monitor" "waf_captcha_requests_anomaly" {
  name    = "[WAF] CAPTCHA Requests Anomaly - {{webacl.name}}"
  type    = "metric alert"
  message = "WAF {{webacl.name}} CAPTCHA requests are anomalous: {{value}} requests ${var.notification_channels}"

  query = "avg(last_15m):anomalies(sum:aws.wafv2.captcha_requests{${var.filter_tags}} by {webacl}, 'basic', 2, direction='both', alert_window='last_15m', interval=60, count_default_zero='true') >= 1"

  monitor_thresholds {
    critical          = 1
    critical_recovery = 0
  }

  notify_no_data    = false
  no_data_timeframe = 20

  tags = concat(var.base_tags, ["service:waf", "severity:info", "metric:captcha_requests"])
}