terraform {
  required_version = ">= 1.0"
  required_providers {
    datadog = {
      source  = "DataDog/datadog"
      version = "~> 3.0"
    }
  }
}

provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
}

# Local values for common configurations
locals {
  common_tags = concat(var.tags, [
    "environment:${var.environment}",
    "project:${var.project_name}",
    "managed_by:terraform"
  ])

  # Default notification message
  default_message = <<-EOT
    {{#is_alert}}
    🚨 **ALERT**: {{rule.name}} 
    {{/is_alert}}
    {{#is_warning}}
    ⚠️ **WARNING**: {{rule.name}}
    {{/is_warning}}
    {{#is_recovery}}
    ✅ **RECOVERED**: {{rule.name}}
    {{/is_recovery}}
    
    **Environment**: ${var.environment}
    **Project**: ${var.project_name}
    **Time**: {{date}}
    
    {{#is_alert}}
    **Action Required**: Immediate investigation needed
    {{/is_alert}}
    {{#is_warning}}
    **Action Required**: Review during business hours
    {{/is_warning}}
    
    **Dashboard**: {{rule.url}}
  EOT
}

# EC2 Monitors
module "ec2_monitors" {
  count  = var.enable_monitors && var.enable_ec2_monitors ? 1 : 0
  source = "./ec2"

  environment                    = var.environment
  project_name                   = var.project_name
  notification_channels          = var.notification_channels
  critical_notification_channels = var.critical_notification_channels
  warning_notification_channels  = var.warning_notification_channels
  tags                           = local.common_tags
  default_message                = local.default_message
}

# CloudFront Monitors
module "cloudfront_monitors" {
  count  = var.enable_monitors && var.enable_cloudfront_monitors ? 1 : 0
  source = "./cloudfront"

  environment                    = var.environment
  project_name                   = var.project_name
  notification_channels          = var.notification_channels
  critical_notification_channels = var.critical_notification_channels
  warning_notification_channels  = var.warning_notification_channels
  tags                           = local.common_tags
  default_message                = local.default_message
}

# ALB Monitors
module "alb_monitors" {
  count  = var.enable_monitors && var.enable_alb_monitors ? 1 : 0
  source = "./alb"

  environment                    = var.environment
  project_name                   = var.project_name
  notification_channels          = var.notification_channels
  critical_notification_channels = var.critical_notification_channels
  warning_notification_channels  = var.warning_notification_channels
  tags                           = local.common_tags
  default_message                = local.default_message
}

# RDS Monitors
module "rds_monitors" {
  count  = var.enable_monitors && var.enable_rds_monitors ? 1 : 0
  source = "./rds"

  environment                    = var.environment
  project_name                   = var.project_name
  notification_channels          = var.notification_channels
  critical_notification_channels = var.critical_notification_channels
  warning_notification_channels  = var.warning_notification_channels
  tags                           = local.common_tags
  default_message                = local.default_message
}

# S3 Monitors
module "s3_monitors" {
  count  = var.enable_monitors && var.enable_s3_monitors ? 1 : 0
  source = "./s3"

  environment                    = var.environment
  project_name                   = var.project_name
  notification_channels          = var.notification_channels
  critical_notification_channels = var.critical_notification_channels
  warning_notification_channels  = var.warning_notification_channels
  tags                           = local.common_tags
  default_message                = local.default_message
}

# DynamoDB Monitors
module "dynamodb_monitors" {
  count  = var.enable_monitors && var.enable_dynamodb_monitors ? 1 : 0
  source = "./dynamodb"

  environment                    = var.environment
  project_name                   = var.project_name
  notification_channels          = var.notification_channels
  critical_notification_channels = var.critical_notification_channels
  warning_notification_channels  = var.warning_notification_channels
  tags                           = local.common_tags
  default_message                = local.default_message
}

# Lambda Monitors
module "lambda_monitors" {
  count  = var.enable_monitors && var.enable_lambda_monitors ? 1 : 0
  source = "./lambda"

  environment                    = var.environment
  project_name                   = var.project_name
  notification_channels          = var.notification_channels
  critical_notification_channels = var.critical_notification_channels
  warning_notification_channels  = var.warning_notification_channels
  tags                           = local.common_tags
  default_message                = local.default_message
}