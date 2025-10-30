#!/bin/bash

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
source "$PROJECT_ROOT/utils/common-functions.sh"
load_config

if ! is_service_enabled "FARGATE"; then
    log_warning "Fargate alarms are disabled in configuration"
    exit 0
fi

log_info "Deploying Fargate CloudWatch Alarms..."

create_alarm "${ALARM_PREFIX}-Fargate-CPU-Critical" "Fargate CPU utilization is high" "CPUUtilization" "AWS/ECS" "90" "GreaterThanThreshold" "$SNS_TOPIC_CRITICAL"
create_alarm "${ALARM_PREFIX}-Fargate-Memory-Critical" "Fargate memory utilization is high" "MemoryUtilization" "AWS/ECS" "90" "GreaterThanThreshold" "$SNS_TOPIC_CRITICAL"
create_alarm "${ALARM_PREFIX}-Fargate-RunningTaskCount-Critical" "Fargate running task count is low" "RunningTaskCount" "AWS/ECS" "1" "LessThanThreshold" "$SNS_TOPIC_CRITICAL"

log_success "Fargate CloudWatch Alarms deployment completed!"