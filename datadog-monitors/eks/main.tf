# EKS Node CPU Utilization - Critical
resource "datadog_monitor" "eks_node_cpu_utilization_critical" {
  name    = "[EKS] Node CPU Utilization Critical - {{node.name}}"
  type    = "metric alert"
  message = "EKS node {{node.name}} CPU utilization is critically high: {{value}}% ${var.notification_channels}"

  query = "avg(last_5m):avg:kubernetes.cpu.usage.total{${var.filter_tags}} by {node} > ${var.eks_node_cpu_critical_threshold}"

  monitor_thresholds {
    critical = var.eks_node_cpu_critical_threshold
    warning  = var.eks_node_cpu_warning_threshold
  }

  notify_no_data    = true
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:eks", "severity:critical", "metric:node_cpu"])
}

# EKS Node Memory Utilization - Critical
resource "datadog_monitor" "eks_node_memory_utilization_critical" {
  name    = "[EKS] Node Memory Utilization Critical - {{node.name}}"
  type    = "metric alert"
  message = "EKS node {{node.name}} memory utilization is critically high: {{value}}% ${var.notification_channels}"

  query = "avg(last_5m):avg:kubernetes.memory.usage{${var.filter_tags}} by {node} > ${var.eks_node_memory_critical_threshold}"

  monitor_thresholds {
    critical = var.eks_node_memory_critical_threshold
    warning  = var.eks_node_memory_warning_threshold
  }

  notify_no_data    = true
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:eks", "severity:critical", "metric:node_memory"])
}

# EKS Pod CPU Utilization - Warning
resource "datadog_monitor" "eks_pod_cpu_utilization_warning" {
  name    = "[EKS] Pod CPU Utilization High - {{pod_name.name}}"
  type    = "metric alert"
  message = "EKS pod {{pod_name.name}} CPU utilization is high: {{value}}% ${var.notification_channels}"

  query = "avg(last_5m):avg:kubernetes.cpu.usage.total{${var.filter_tags}} by {pod_name} > ${var.eks_pod_cpu_critical_threshold}"

  monitor_thresholds {
    critical = var.eks_pod_cpu_critical_threshold
    warning  = var.eks_pod_cpu_warning_threshold
  }

  notify_no_data    = false
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:eks", "severity:warning", "metric:pod_cpu"])
}

# EKS Pod Memory Utilization - Warning
resource "datadog_monitor" "eks_pod_memory_utilization_warning" {
  name    = "[EKS] Pod Memory Utilization High - {{pod_name.name}}"
  type    = "metric alert"
  message = "EKS pod {{pod_name.name}} memory utilization is high: {{value}}% ${var.notification_channels}"

  query = "avg(last_5m):avg:kubernetes.memory.usage{${var.filter_tags}} by {pod_name} > ${var.eks_pod_memory_critical_threshold}"

  monitor_thresholds {
    critical = var.eks_pod_memory_critical_threshold
    warning  = var.eks_pod_memory_warning_threshold
  }

  notify_no_data    = false
  no_data_timeframe = 10

  tags = concat(var.base_tags, ["service:eks", "severity:warning", "metric:pod_memory"])
}

# EKS Pod Restart Count - Critical
resource "datadog_monitor" "eks_pod_restart_count_critical" {
  name    = "[EKS] Pod Restart Count Critical - {{pod_name.name}}"
  type    = "metric alert"
  message = "EKS pod {{pod_name.name}} restart count is high: {{value}} restarts in 1h ${var.notification_channels}"

  query = "avg(last_1h):diff(avg:kubernetes.containers.restarts{${var.filter_tags}} by {pod_name}) > ${var.eks_pod_restart_critical_threshold}"

  monitor_thresholds {
    critical = var.eks_pod_restart_critical_threshold
    warning  = var.eks_pod_restart_warning_threshold
  }

  notify_no_data    = false
  no_data_timeframe = 60

  tags = concat(var.base_tags, ["service:eks", "severity:critical", "metric:pod_restarts"])
}