variable "eks_node_cpu_critical_threshold" {
  description = "Critical threshold for EKS node CPU utilization (%)"
  type        = number
  default     = 90
}

variable "eks_node_cpu_warning_threshold" {
  description = "Warning threshold for EKS node CPU utilization (%)"
  type        = number
  default     = 80
}

variable "eks_node_memory_critical_threshold" {
  description = "Critical threshold for EKS node memory utilization (%)"
  type        = number
  default     = 90
}

variable "eks_node_memory_warning_threshold" {
  description = "Warning threshold for EKS node memory utilization (%)"
  type        = number
  default     = 80
}

variable "eks_pod_cpu_critical_threshold" {
  description = "Critical threshold for EKS pod CPU utilization (% of request)"
  type        = number
  default     = 90
}

variable "eks_pod_cpu_warning_threshold" {
  description = "Warning threshold for EKS pod CPU utilization (% of request)"
  type        = number
  default     = 80
}

variable "eks_pod_memory_critical_threshold" {
  description = "Critical threshold for EKS pod memory utilization (% of request)"
  type        = number
  default     = 90
}

variable "eks_pod_memory_warning_threshold" {
  description = "Warning threshold for EKS pod memory utilization (% of request)"
  type        = number
  default     = 80
}

variable "eks_pod_restart_critical_threshold" {
  description = "Critical threshold for EKS pod restart count in 1 hour"
  type        = number
  default     = 5
}

variable "eks_pod_restart_warning_threshold" {
  description = "Warning threshold for EKS pod restart count in 1 hour"
  type        = number
  default     = 3
}