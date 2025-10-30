output "ec2_monitor_ids" {
  description = "IDs of EC2 monitors"
  value       = var.enable_monitors && var.enable_ec2_monitors ? module.ec2_monitors[0].monitor_ids : {}
}

output "cloudfront_monitor_ids" {
  description = "IDs of CloudFront monitors"
  value       = var.enable_monitors && var.enable_cloudfront_monitors ? module.cloudfront_monitors[0].monitor_ids : {}
}

output "alb_monitor_ids" {
  description = "IDs of ALB monitors"
  value       = var.enable_monitors && var.enable_alb_monitors ? module.alb_monitors[0].monitor_ids : {}
}

output "rds_monitor_ids" {
  description = "IDs of RDS monitors"
  value       = var.enable_monitors && var.enable_rds_monitors ? module.rds_monitors[0].monitor_ids : {}
}

output "aurora_monitor_ids" {
  description = "IDs of Aurora monitors"
  value       = var.enable_monitors && var.enable_aurora_monitors ? module.aurora_monitors[0].monitor_ids : {}
}

output "s3_monitor_ids" {
  description = "IDs of S3 monitors"
  value       = var.enable_monitors && var.enable_s3_monitors ? module.s3_monitors[0].monitor_ids : {}
}

output "dynamodb_monitor_ids" {
  description = "IDs of DynamoDB monitors"
  value       = var.enable_monitors && var.enable_dynamodb_monitors ? module.dynamodb_monitors[0].monitor_ids : {}
}

output "lambda_monitor_ids" {
  description = "IDs of Lambda monitors"
  value       = var.enable_monitors && var.enable_lambda_monitors ? module.lambda_monitors[0].monitor_ids : {}
}

output "s3_monitor_ids" {
  description = "IDs of S3 monitors"
  value       = var.enable_monitors && var.enable_s3_monitors ? module.s3_monitors[0].monitor_ids : {}
}

output "dynamodb_monitor_ids" {
  description = "IDs of DynamoDB monitors"
  value       = var.enable_monitors && var.enable_dynamodb_monitors ? module.dynamodb_monitors[0].monitor_ids : {}
}

output "lambda_monitor_ids" {
  description = "IDs of Lambda monitors"
  value       = var.enable_monitors && var.enable_lambda_monitors ? module.lambda_monitors[0].monitor_ids : {}
}

output "all_monitor_count" {
  description = "Total number of monitors created"
  value = (
    (var.enable_monitors && var.enable_ec2_monitors ? length(module.ec2_monitors[0].monitor_ids) : 0) +
    (var.enable_monitors && var.enable_cloudfront_monitors ? length(module.cloudfront_monitors[0].monitor_ids) : 0) +
    (var.enable_monitors && var.enable_alb_monitors ? length(module.alb_monitors[0].monitor_ids) : 0) +
    (var.enable_monitors && var.enable_rds_monitors ? length(module.rds_monitors[0].monitor_ids) : 0) +
    (var.enable_monitors && var.enable_s3_monitors ? length(module.s3_monitors[0].monitor_ids) : 0) +
    (var.enable_monitors && var.enable_dynamodb_monitors ? length(module.dynamodb_monitors[0].monitor_ids) : 0) +
    (var.enable_monitors && var.enable_lambda_monitors ? length(module.lambda_monitors[0].monitor_ids) : 0)
  )
}