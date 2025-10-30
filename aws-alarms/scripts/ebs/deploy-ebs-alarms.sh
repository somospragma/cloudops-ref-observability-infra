#!/bin/bash

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
source "$PROJECT_ROOT/utils/common-functions.sh"
load_config

if ! is_service_enabled "EBS"; then
    log_warning "EBS alarms are disabled in configuration"
    exit 0
fi

log_info "Deploying EBS CloudWatch Alarms..."

create_alarm "${ALARM_PREFIX}-EBS-VolumeQueueLength-Critical" "EBS volume queue length is high" "VolumeQueueLength" "AWS/EBS" "32" "GreaterThanThreshold" "$SNS_TOPIC_CRITICAL"
create_alarm "${ALARM_PREFIX}-EBS-VolumeThroughputPercentage-Critical" "EBS throughput percentage is high" "VolumeThroughputPercentage" "AWS/EBS" "90" "GreaterThanThreshold" "$SNS_TOPIC_CRITICAL"
create_alarm "${ALARM_PREFIX}-EBS-BurstBalance-Critical" "EBS burst balance is low" "BurstBalance" "AWS/EBS" "10" "LessThanThreshold" "$SNS_TOPIC_CRITICAL"

aws cloudwatch put-anomaly-detector --namespace "AWS/EBS" --metric-name "VolumeReadOps" --stat "Average" --profile "$AWS_PROFILE" --region "$AWS_REGION"
aws cloudwatch put-anomaly-detector --namespace "AWS/EBS" --metric-name "VolumeWriteOps" --stat "Average" --profile "$AWS_PROFILE" --region "$AWS_REGION"

log_success "EBS CloudWatch Alarms deployment completed!"