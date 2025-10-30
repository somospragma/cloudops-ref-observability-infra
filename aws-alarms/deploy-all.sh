#!/bin/bash

# Deploy All AWS CloudWatch Alarms
# Master deployment script

set -e

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load common functions and configuration
source "$SCRIPT_DIR/utils/common-functions.sh"

# Load configuration first, then check AWS CLI
load_config
check_aws_cli

log_info "Starting AWS CloudWatch Alarms deployment..."
log_info "Project: $PROJECT_NAME"
log_info "Environment: $ENVIRONMENT"
log_info "Region: $AWS_REGION"

# Validate SNS topics
log_info "Validating SNS topics..."
if ! validate_sns_topic "$SNS_TOPIC_CRITICAL"; then
    log_error "Critical SNS topic is not accessible: $SNS_TOPIC_CRITICAL"
    log_info "Please create the SNS topic or update the configuration"
    exit 1
fi

if ! validate_sns_topic "$SNS_TOPIC_WARNING"; then
    log_error "Warning SNS topic is not accessible: $SNS_TOPIC_WARNING"
    log_info "Please create the SNS topic or update the configuration"
    exit 1
fi

log_success "SNS topics validated successfully"

# Array of services to deploy
services=(
    "ec2:EC2"
    "rds:RDS" 
    "lambda:Lambda"
    "s3:S3"
    "dynamodb:DynamoDB"
    "cloudfront:CloudFront"
    "alb:ALB"
    "api-gateway:API Gateway"
    "elasticache:ElastiCache"
    "ecs:ECS"
    "aurora:Aurora"
    "aurora-serverless:Aurora Serverless"
    "ebs:EBS"
    "efs:EFS"
    "eks:EKS"
    "fargate:Fargate"
    "fsx:FSx"
    "glue:Glue"
    "redshift:Redshift"
    "waf:WAF"
)

# Deploy each service
total_services=${#services[@]}
current_service=0

for service_info in "${services[@]}"; do
    IFS=':' read -r service_dir service_name <<< "$service_info"
    current_service=$((current_service + 1))
    
    show_progress "$current_service" "$total_services" "$service_name"
    
    script_path="$SCRIPT_DIR/scripts/$service_dir/deploy-${service_dir}-alarms.sh"
    
    if [[ -f "$script_path" ]]; then
        if [[ -x "$script_path" ]]; then
            log_info "Deploying $service_name alarms..."
            if "$script_path"; then
                log_success "$service_name alarms deployed successfully"
            else
                log_error "Failed to deploy $service_name alarms"
                exit 1
            fi
        else
            log_warning "Script not executable: $script_path"
            chmod +x "$script_path"
            log_info "Made script executable, please run again"
        fi
    else
        log_warning "Script not found: $script_path"
    fi
    
    echo # Add spacing between services
done

log_success "All AWS CloudWatch Alarms deployed successfully!"

# Summary
log_info "Deployment Summary:"
log_info "  Project: $PROJECT_NAME"
log_info "  Environment: $ENVIRONMENT"
log_info "  Region: $AWS_REGION"
log_info "  Services deployed: $total_services/20 AWS services"

# List created alarms
log_info "Listing created alarms..."
list_alarms "$ALARM_PREFIX"

log_info "Deployment completed! 🎉"
log_info ""
log_info "Next steps:"
log_info "  1. Verify alarms in AWS Console: https://console.aws.amazon.com/cloudwatch/home?region=$AWS_REGION#alarmsV2:"
log_info "  2. Test SNS notifications"
log_info "  3. Monitor alarm states"
log_info ""
log_info "To test notifications:"
log_info "  ./utils/test-notifications.sh"
log_info ""
log_info "To delete all alarms:"
log_info "  ./delete-all-alarms.sh"