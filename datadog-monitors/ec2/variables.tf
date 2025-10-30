variable "environment" {
  description = "Environment name"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "notification_channels" {
  description = "List of notification channels"
  type        = list(string)
  default     = []
}

variable "critical_notification_channels" {
  description = "List of critical notification channels"
  type        = list(string)
  default     = []
}

variable "warning_notification_channels" {
  description = "List of warning notification channels"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "List of tags to apply to monitors"
  type        = list(string)
  default     = []
}

variable "default_message" {
  description = "Default message template for monitors"
  type        = string
}

# EC2 CPU Thresholds
variable "cpu_critical_threshold" {
  description = "Critical threshold for EC2 CPU utilization (%)"
  type        = number
  default     = 90
}

variable "cpu_warning_threshold" {
  description = "Warning threshold for EC2 CPU utilization (%)"
  type        = number
  default     = 80
}

# EC2 Network Thresholds (bytes)
variable "network_in_critical_threshold" {
  description = "Critical threshold for EC2 network in (bytes)"
  type        = number
  default     = 1000000000 # 1GB - adjust based on baseline
}

variable "network_in_warning_threshold" {
  description = "Warning threshold for EC2 network in (bytes)"
  type        = number
  default     = 750000000 # 750MB - adjust based on baseline
}

variable "network_out_critical_threshold" {
  description = "Critical threshold for EC2 network out (bytes)"
  type        = number
  default     = 1000000000 # 1GB - adjust based on baseline
}

variable "network_out_warning_threshold" {
  description = "Warning threshold for EC2 network out (bytes)"
  type        = number
  default     = 750000000 # 750MB - adjust based on baseline
}

# EC2 EBS Balance Thresholds (%)
variable "ebs_io_balance_critical_threshold" {
  description = "Critical threshold for EBS IO balance (%)"
  type        = number
  default     = 10
}

variable "ebs_io_balance_warning_threshold" {
  description = "Warning threshold for EBS IO balance (%)"
  type        = number
  default     = 20
}

variable "ebs_byte_balance_critical_threshold" {
  description = "Critical threshold for EBS byte balance (%)"
  type        = number
  default     = 10
}

variable "ebs_byte_balance_warning_threshold" {
  description = "Warning threshold for EBS byte balance (%)"
  type        = number
  default     = 20
}

# Disk Operations Thresholds
variable "disk_read_ops_critical_threshold" {
  description = "Critical threshold for disk read operations"
  type        = number
  default     = 1000 # adjust based on baseline
}

variable "disk_read_ops_warning_threshold" {
  description = "Warning threshold for disk read operations"
  type        = number
  default     = 750 # adjust based on baseline
}

variable "disk_write_ops_critical_threshold" {
  description = "Critical threshold for disk write operations"
  type        = number
  default     = 1000 # adjust based on baseline
}

variable "disk_write_ops_warning_threshold" {
  description = "Warning threshold for disk write operations"
  type        = number
  default     = 750 # adjust based on baseline
}