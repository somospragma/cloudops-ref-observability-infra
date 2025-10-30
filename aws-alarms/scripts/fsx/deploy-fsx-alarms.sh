#!/bin/bash

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
source "$PROJECT_ROOT/utils/common-functions.sh"
load_config

if ! is_service_enabled "FSX"; then
    log_warning "FSx alarms are disabled in configuration"
    exit 0
fi

log_info "Deploying FSx CloudWatch Alarms..."

create_alarm "${ALARM_PREFIX}-FSx-StorageUtilization-Warning" "FSx storage utilization is high" "StorageUtilization" "AWS/FSx" "90" "GreaterThanThreshold" "$SNS_TOPIC_WARNING"

aws cloudwatch put-anomaly-detector --namespace "AWS/FSx" --metric-name "DataReadBytes" --stat "Sum" --profile "$AWS_PROFILE" --region "$AWS_REGION"
aws cloudwatch put-anomaly-detector --namespace "AWS/FSx" --metric-name "DataWriteBytes" --stat "Sum" --profile "$AWS_PROFILE" --region "$AWS_REGION"
aws cloudwatch put-anomaly-detector --namespace "AWS/FSx" --metric-name "MetadataOperations" --stat "Sum" --profile "$AWS_PROFILE" --region "$AWS_REGION"

log_success "FSx CloudWatch Alarms deployment completed!"