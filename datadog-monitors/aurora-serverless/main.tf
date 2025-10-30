# Aurora Serverless Database Capacity - Critical
resource "datadog_monitor" "aurora_serverless_capacity_critical" {
  name    = "[Aurora Serverless] Database Capacity Critical - {{db_cluster_identifier.name}}"
  type    = "metric alert"
  message = "Aurora Serverless cluster {{db_cluster_identifier.name}} capacity is critically high: {{value}}% ${var.notification_channels}"

  query = "avg(last_5m):avg:aws.rds.serverless_database_capacity{${var.filter_tags}} by {db_cluster_identifier} > ${var.aurora_serverless_capacity_critical_threshold}"

  monitor_thresholds {
    critical = var.aurora_serverless_capacity_critical_threshold
    warning  = var.aurora_serverless_capacity_warning_threshold
  }

  notify_no_data    = false
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:aurora-serverless", "severity:critical", "metric:capacity"])
}

# Aurora Serverless ACU Utilization - Critical
resource "datadog_monitor" "aurora_serverless_acu_utilization_critical" {
  name    = "[Aurora Serverless] ACU Utilization Critical - {{db_cluster_identifier.name}}"
  type    = "metric alert"
  message = "Aurora Serverless cluster {{db_cluster_identifier.name}} ACU utilization is critically high: {{value}}% ${var.notification_channels}"

  query = "avg(last_5m):avg:aws.rds.acu_utilization{${var.filter_tags}} by {db_cluster_identifier} > ${var.aurora_serverless_acu_critical_threshold}"

  monitor_thresholds {
    critical = var.aurora_serverless_acu_critical_threshold
    warning  = var.aurora_serverless_acu_warning_threshold
  }

  notify_no_data    = false
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:aurora-serverless", "severity:critical", "metric:acu_utilization"])
}

# Aurora Serverless Database Connections - Critical
resource "datadog_monitor" "aurora_serverless_connections_critical" {
  name    = "[Aurora Serverless] Database Connections Critical - {{db_cluster_identifier.name}}"
  type    = "metric alert"
  message = "Aurora Serverless cluster {{db_cluster_identifier.name}} database connections are high: {{value}} ${var.notification_channels}"

  query = "avg(last_5m):avg:aws.rds.database_connections{${var.filter_tags},engine:aurora-mysql} by {db_cluster_identifier} > ${var.aurora_serverless_connections_critical_threshold}"

  monitor_thresholds {
    critical = var.aurora_serverless_connections_critical_threshold
    warning  = var.aurora_serverless_connections_warning_threshold
  }

  notify_no_data    = false
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:aurora-serverless", "severity:critical", "metric:connections"])
}

# Aurora Serverless Query Duration - Performance
resource "datadog_monitor" "aurora_serverless_query_duration_warning" {
  name    = "[Aurora Serverless] Query Duration High - {{db_cluster_identifier.name}}"
  type    = "metric alert"
  message = "Aurora Serverless cluster {{db_cluster_identifier.name}} query duration is high: {{value}}s ${var.notification_channels}"

  query = "avg(last_5m):avg:aws.rds.query_duration{${var.filter_tags}} by {db_cluster_identifier} > ${var.aurora_serverless_query_duration_critical_threshold}"

  monitor_thresholds {
    critical = var.aurora_serverless_query_duration_critical_threshold
    warning  = var.aurora_serverless_query_duration_warning_threshold
  }

  notify_no_data    = false
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:aurora-serverless", "severity:warning", "metric:query_duration"])
}

# Aurora Serverless Select Latency - Performance
resource "datadog_monitor" "aurora_serverless_select_latency_warning" {
  name    = "[Aurora Serverless] Select Latency High - {{db_cluster_identifier.name}}"
  type    = "metric alert"
  message = "Aurora Serverless cluster {{db_cluster_identifier.name}} SELECT latency is high: {{value}}ms ${var.notification_channels}"

  query = "avg(last_5m):avg:aws.rds.select_latency{${var.filter_tags},engine:aurora-mysql} by {db_cluster_identifier} > ${var.aurora_serverless_select_latency_critical_threshold}"

  monitor_thresholds {
    critical = var.aurora_serverless_select_latency_critical_threshold
    warning  = var.aurora_serverless_select_latency_warning_threshold
  }

  notify_no_data    = false
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:aurora-serverless", "severity:warning", "metric:select_latency"])
}