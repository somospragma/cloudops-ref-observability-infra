# ECS CPU Utilization - Critical
resource "datadog_monitor" "ecs_cpu_utilization_critical" {
  name    = "[ECS] CPU Utilization Critical - {{servicename.name}}"
  type    = "metric alert"
  message = "ECS service {{servicename.name}} CPU utilization is critically high: {{value}}% ${var.notification_channels}"

  query = "avg(last_5m):avg:aws.ecs.cpuutilization{${var.filter_tags}} by {servicename} > ${var.ecs_cpu_critical_threshold}"

  monitor_thresholds {
    critical = var.ecs_cpu_critical_threshold
    warning  = var.ecs_cpu_warning_threshold
  }

  notify_no_data    = true
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:ecs", "severity:critical", "metric:cpu"])
}

# ECS Memory Utilization - Critical
resource "datadog_monitor" "ecs_memory_utilization_critical" {
  name    = "[ECS] Memory Utilization Critical - {{servicename.name}}"
  type    = "metric alert"
  message = "ECS service {{servicename.name}} memory utilization is critically high: {{value}}% ${var.notification_channels}"

  query = "avg(last_5m):avg:aws.ecs.memory_utilization{${var.filter_tags}} by {servicename} > ${var.ecs_memory_critical_threshold}"

  monitor_thresholds {
    critical = var.ecs_memory_critical_threshold
    warning  = var.ecs_memory_warning_threshold
  }

  notify_no_data    = true
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:ecs", "severity:critical", "metric:memory"])
}

# ECS Running Task Count - Critical
resource "datadog_monitor" "ecs_running_task_count_critical" {
  name    = "[ECS] Running Task Count Critical - {{servicename.name}}"
  type    = "metric alert"
  message = "ECS service {{servicename.name}} running task count is below desired: {{value}} ${var.notification_channels}"

  query = "avg(last_5m):avg:aws.ecs.running_task_count{${var.filter_tags}} by {servicename} < ${var.ecs_running_task_critical_threshold}"

  monitor_thresholds {
    critical = var.ecs_running_task_critical_threshold
  }

  notify_no_data    = true
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:ecs", "severity:critical", "metric:running_tasks"])
}

# ECS Pending Task Count - Warning
resource "datadog_monitor" "ecs_pending_task_count_warning" {
  name    = "[ECS] Pending Task Count High - {{servicename.name}}"
  type    = "metric alert"
  message = "ECS service {{servicename.name}} has pending tasks for too long: {{value}} ${var.notification_channels}"

  query = "avg(last_5m):avg:aws.ecs.pending_task_count{${var.filter_tags}} by {servicename} > ${var.ecs_pending_task_critical_threshold}"

  monitor_thresholds {
    critical = var.ecs_pending_task_critical_threshold
    warning  = var.ecs_pending_task_warning_threshold
  }

  notify_no_data    = false
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:ecs", "severity:warning", "metric:pending_tasks"])
}

# ECS Active Services Count - Monitoring
resource "datadog_monitor" "ecs_active_services_count_anomaly" {
  name    = "[ECS] Active Services Count Anomaly - {{clustername.name}}"
  type    = "metric alert"
  message = "ECS cluster {{clustername.name}} active services count is anomalous: {{value}} ${var.notification_channels}"

  query = "avg(last_15m):anomalies(avg:aws.ecs.active_services_count{${var.filter_tags}} by {clustername}, 'basic', 2, direction='both', alert_window='last_15m', interval=60, count_default_zero='true') >= 1"

  monitor_thresholds {
    critical          = 1
    critical_recovery = 0
  }

  notify_no_data    = false
  no_data_timeframe = 20

  tags = concat(var.base_tags, ["service:ecs", "severity:info", "metric:active_services"])
}