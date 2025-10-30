# Glue Failed Tasks - Critical
resource "datadog_monitor" "glue_failed_tasks_critical" {
  name    = "[Glue] Failed Tasks Critical - {{job_name.name}}"
  type    = "metric alert"
  message = "Glue job {{job_name.name}} failed task rate is high: {{value}}% ${var.notification_channels}"

  query = "avg(last_5m):( avg:aws.glue.driver.aggregate.numfailedtasks{${var.filter_tags}} by {job_name} / avg:aws.glue.driver.aggregate.numcompletedtasks{${var.filter_tags}} by {job_name} ) * 100 > ${var.glue_failed_tasks_critical_threshold}"

  monitor_thresholds {
    critical = var.glue_failed_tasks_critical_threshold
    warning  = var.glue_failed_tasks_warning_threshold
  }

  notify_no_data    = false
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:glue", "severity:critical", "metric:failed_tasks"])
}

# Glue Killed Tasks - Critical
resource "datadog_monitor" "glue_killed_tasks_critical" {
  name    = "[Glue] Killed Tasks Critical - {{job_name.name}}"
  type    = "metric alert"
  message = "Glue job {{job_name.name}} has killed tasks: {{value}} ${var.notification_channels}"

  query = "avg(last_5m):avg:aws.glue.driver.aggregate.numkilledtasks{${var.filter_tags}} by {job_name} > ${var.glue_killed_tasks_threshold}"

  monitor_thresholds {
    critical = var.glue_killed_tasks_threshold
  }

  notify_no_data    = false
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:glue", "severity:critical", "metric:killed_tasks"])
}

# Glue Job Elapsed Time - Performance
resource "datadog_monitor" "glue_elapsed_time_warning" {
  name    = "[Glue] Job Elapsed Time High - {{job_name.name}}"
  type    = "metric alert"
  message = "Glue job {{job_name.name}} elapsed time is high: {{value}}s ${var.notification_channels}"

  query = "avg(last_5m):avg:aws.glue.driver.aggregate.elapsedtime{${var.filter_tags}} by {job_name} > ${var.glue_elapsed_time_critical_threshold}"

  monitor_thresholds {
    critical = var.glue_elapsed_time_critical_threshold
    warning  = var.glue_elapsed_time_warning_threshold
  }

  notify_no_data    = false
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:glue", "severity:warning", "metric:elapsed_time"])
}

# Glue JVM Heap Usage - Performance
resource "datadog_monitor" "glue_jvm_heap_usage_warning" {
  name    = "[Glue] JVM Heap Usage High - {{job_name.name}}"
  type    = "metric alert"
  message = "Glue job {{job_name.name}} JVM heap usage is high: {{value}}% ${var.notification_channels}"

  query = "avg(last_5m):avg:aws.glue.driver.jvm.heap.usage{${var.filter_tags}} by {job_name} > ${var.glue_heap_usage_critical_threshold}"

  monitor_thresholds {
    critical = var.glue_heap_usage_critical_threshold
    warning  = var.glue_heap_usage_warning_threshold
  }

  notify_no_data    = false
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:glue", "severity:warning", "metric:heap_usage"])
}