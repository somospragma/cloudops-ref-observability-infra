# Fargate CPU Utilization - Critical
resource "datadog_monitor" "fargate_cpu_utilization_critical" {
  name    = "[Fargate] CPU Utilization Critical - {{servicename.name}}"
  type    = "metric alert"
  message = "Fargate service {{servicename.name}} CPU utilization is critically high: {{value}}% ${var.notification_channels}"

  query = "avg(last_5m):avg:aws.ecs.cpuutilization{${var.filter_tags},launch_type:fargate} by {servicename} > ${var.fargate_cpu_critical_threshold}"

  monitor_thresholds {
    critical = var.fargate_cpu_critical_threshold
    warning  = var.fargate_cpu_warning_threshold
  }

  notify_no_data    = true
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:fargate", "severity:critical", "metric:cpu"])
}

# Fargate Memory Utilization - Critical
resource "datadog_monitor" "fargate_memory_utilization_critical" {
  name    = "[Fargate] Memory Utilization Critical - {{servicename.name}}"
  type    = "metric alert"
  message = "Fargate service {{servicename.name}} memory utilization is critically high: {{value}}% ${var.notification_channels}"

  query = "avg(last_5m):avg:aws.ecs.memory_utilization{${var.filter_tags},launch_type:fargate} by {servicename} > ${var.fargate_memory_critical_threshold}"

  monitor_thresholds {
    critical = var.fargate_memory_critical_threshold
    warning  = var.fargate_memory_warning_threshold
  }

  notify_no_data    = true
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:fargate", "severity:critical", "metric:memory"])
}

# Fargate Running Task Count - Critical
resource "datadog_monitor" "fargate_running_task_count_critical" {
  name    = "[Fargate] Running Task Count Critical - {{servicename.name}}"
  type    = "metric alert"
  message = "Fargate service {{servicename.name}} running task count is below desired: {{value}} ${var.notification_channels}"

  query = "avg(last_5m):avg:aws.ecs.running_task_count{${var.filter_tags},launch_type:fargate} by {servicename} < ${var.fargate_running_task_critical_threshold}"

  monitor_thresholds {
    critical = var.fargate_running_task_critical_threshold
  }

  notify_no_data    = true
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:fargate", "severity:critical", "metric:running_tasks"])
}

# Fargate Pending Task Count - Warning
resource "datadog_monitor" "fargate_pending_task_count_warning" {
  name    = "[Fargate] Pending Task Count High - {{servicename.name}}"
  type    = "metric alert"
  message = "Fargate service {{servicename.name}} has pending tasks for too long: {{value}} ${var.notification_channels}"

  query = "avg(last_5m):avg:aws.ecs.pending_task_count{${var.filter_tags},launch_type:fargate} by {servicename} > ${var.fargate_pending_task_critical_threshold}"

  monitor_thresholds {
    critical = var.fargate_pending_task_critical_threshold
    warning  = var.fargate_pending_task_warning_threshold
  }

  notify_no_data    = false
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:fargate", "severity:warning", "metric:pending_tasks"])
}