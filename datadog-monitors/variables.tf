variable "datadog_api_key" {
  description = "Datadog API Key"
  type        = string
  sensitive   = true
}

variable "datadog_app_key" {
  description = "Datadog Application Key"
  type        = string
  sensitive   = true
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "notification_channels" {
  description = "List of notification channels for alerts"
  type        = list(string)
  default     = []
}

variable "critical_notification_channels" {
  description = "List of notification channels for critical alerts"
  type        = list(string)
  default     = []
}

variable "warning_notification_channels" {
  description = "List of notification channels for warning alerts"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Common tags to apply to all monitors"
  type        = list(string)
  default     = []
}

variable "enable_monitors" {
  description = "Global flag to enable/disable all monitors"
  type        = bool
  default     = true
}

# Service-specific enable flags
variable "enable_ec2_monitors" {
  description = "Enable EC2 monitors"
  type        = bool
  default     = true
}

variable "enable_cloudfront_monitors" {
  description = "Enable CloudFront monitors"
  type        = bool
  default     = true
}

variable "enable_alb_monitors" {
  description = "Enable ALB monitors"
  type        = bool
  default     = true
}

variable "enable_rds_monitors" {
  description = "Enable RDS monitors"
  type        = bool
  default     = true
}

variable "enable_aurora_monitors" {
  description = "Enable Aurora monitors"
  type        = bool
  default     = true
}

variable "enable_aurora_serverless_monitors" {
  description = "Enable Aurora Serverless monitors"
  type        = bool
  default     = true
}

variable "enable_s3_monitors" {
  description = "Enable S3 monitors"
  type        = bool
  default     = true
}

variable "enable_dynamodb_monitors" {
  description = "Enable DynamoDB monitors"
  type        = bool
  default     = true
}

variable "enable_lambda_monitors" {
  description = "Enable Lambda monitors"
  type        = bool
  default     = true
}

variable "enable_efs_monitors" {
  description = "Enable EFS monitors"
  type        = bool
  default     = true
}

variable "enable_ebs_monitors" {
  description = "Enable EBS monitors"
  type        = bool
  default     = true
}

variable "enable_fsx_monitors" {
  description = "Enable FSx monitors"
  type        = bool
  default     = true
}

variable "enable_waf_monitors" {
  description = "Enable WAF monitors"
  type        = bool
  default     = true
}

variable "enable_redshift_monitors" {
  description = "Enable Redshift monitors"
  type        = bool
  default     = true
}

variable "enable_glue_monitors" {
  description = "Enable Glue monitors"
  type        = bool
  default     = true
}

variable "enable_elasticache_monitors" {
  description = "Enable ElastiCache monitors"
  type        = bool
  default     = true
}

variable "enable_eks_monitors" {
  description = "Enable EKS monitors"
  type        = bool
  default     = true
}

variable "enable_ecs_monitors" {
  description = "Enable ECS monitors"
  type        = bool
  default     = true
}

variable "enable_fargate_monitors" {
  description = "Enable Fargate monitors"
  type        = bool
  default     = true
}

variable "enable_api_gateway_monitors" {
  description = "Enable API Gateway monitors"
  type        = bool
  default     = true
}