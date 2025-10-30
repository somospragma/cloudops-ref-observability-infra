#!/bin/bash

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
source "$PROJECT_ROOT/utils/common-functions.sh"
load_config

if ! is_service_enabled "EFS"; then
    log_warning "EFS alarms are disabled in configuration"
    exit 0
fi

log_info "Deploying EFS CloudWatch Alarms..."

create_alarm "${ALARM_PREFIX}-EFS-PercentIOLimit-Critical" "EFS percent IO limit is high" "PercentIOLimit" "AWS/EFS" "80" "GreaterThanThreshold" "$SNS_TOPIC_CRITICAL"
create_alarm "${ALARM_PREFIX}-EFS-BurstCreditBalance-Critical" "EFS burst credit balance is low" "BurstCreditBalance" "AWS/EFS" "1073741824" "LessThanThreshold" "$SNS_TOPIC_CRITICAL"
create_alarm "${ALARM_PREFIX}-EFS-ClientConnections-Critical" "EFS client connections are high" "ClientConnections" "AWS/EFS" "1000" "GreaterThanThreshold" "$SNS_TOPIC_CRITICAL"

aws cloudwatch put-anomaly-detector --namespace "AWS/EFS" --metric-name "TotalIOBytes" --stat "Sum" --profile "$AWS_PROFILE" --region "$AWS_REGION"

log_success "EFS CloudWatch Alarms deployment completed!"