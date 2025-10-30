#!/bin/bash

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
source "$PROJECT_ROOT/utils/common-functions.sh"
load_config

if ! is_service_enabled "REDSHIFT"; then
    log_warning "Redshift alarms are disabled in configuration"
    exit 0
fi

log_info "Deploying Redshift CloudWatch Alarms..."

create_alarm "${ALARM_PREFIX}-Redshift-CPU-Critical" "Redshift CPU utilization is high" "CPUUtilization" "AWS/Redshift" "90" "GreaterThanThreshold" "$SNS_TOPIC_CRITICAL"
create_alarm "${ALARM_PREFIX}-Redshift-DatabaseConnections-Critical" "Redshift database connections are high" "DatabaseConnections" "AWS/Redshift" "400" "GreaterThanThreshold" "$SNS_TOPIC_CRITICAL"
create_alarm "${ALARM_PREFIX}-Redshift-PercentageDiskSpaceUsed-Critical" "Redshift disk space usage is high" "PercentageDiskSpaceUsed" "AWS/Redshift" "90" "GreaterThanThreshold" "$SNS_TOPIC_CRITICAL"
create_alarm "${ALARM_PREFIX}-Redshift-ReadLatency-Warning" "Redshift read latency is high" "ReadLatency" "AWS/Redshift" "1" "GreaterThanThreshold" "$SNS_TOPIC_WARNING"
create_alarm "${ALARM_PREFIX}-Redshift-WriteLatency-Warning" "Redshift write latency is high" "WriteLatency" "AWS/Redshift" "1" "GreaterThanThreshold" "$SNS_TOPIC_WARNING"

log_success "Redshift CloudWatch Alarms deployment completed!"