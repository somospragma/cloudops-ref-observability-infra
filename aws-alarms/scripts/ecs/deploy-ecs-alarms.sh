#!/bin/bash

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
source "$PROJECT_ROOT/utils/common-functions.sh"
load_config

if ! is_service_enabled "ECS"; then
    log_warning "ECS alarms are disabled in configuration"
    exit 0
fi

log_info "Deploying ECS CloudWatch Alarms..."

create_alarm \
    "${ALARM_PREFIX}-ECS-CPU-Critical" \
    "ECS CPU utilization is critically high" \
    "CPUUtilization" \
    "AWS/ECS" \
    "$ECS_CPU_CRITICAL_THRESHOLD" \
    "GreaterThanThreshold" \
    "$SNS_TOPIC_CRITICAL"

create_alarm \
    "${ALARM_PREFIX}-ECS-Memory-Critical" \
    "ECS memory utilization is critically high" \
    "MemoryUtilization" \
    "AWS/ECS" \
    "$ECS_MEMORY_CRITICAL_THRESHOLD" \
    "GreaterThanThreshold" \
    "$SNS_TOPIC_CRITICAL"

create_alarm \
    "${ALARM_PREFIX}-ECS-RunningTaskCount-Critical" \
    "ECS running task count is below desired" \
    "RunningTaskCount" \
    "AWS/ECS" \
    "1" \
    "LessThanThreshold" \
    "$SNS_TOPIC_CRITICAL"

create_alarm \
    "${ALARM_PREFIX}-ECS-PendingTaskCount-Warning" \
    "ECS has pending tasks for too long" \
    "PendingTaskCount" \
    "AWS/ECS" \
    "1" \
    "GreaterThanThreshold" \
    "$SNS_TOPIC_WARNING"

aws cloudwatch put-anomaly-detector \
    --namespace "AWS/ECS" \
    --metric-name "ActiveServicesCount" \
    --stat "Average" \
    --profile "$AWS_PROFILE" --region "$AWS_REGION"

log_success "ECS CloudWatch Alarms deployment completed!"