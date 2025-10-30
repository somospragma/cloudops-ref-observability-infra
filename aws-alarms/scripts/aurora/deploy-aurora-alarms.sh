#!/bin/bash

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
source "$PROJECT_ROOT/utils/common-functions.sh"
load_config

if ! is_service_enabled "AURORA"; then
    log_warning "Aurora alarms are disabled in configuration"
    exit 0
fi

log_info "Deploying Aurora CloudWatch Alarms..."

create_alarm "${ALARM_PREFIX}-Aurora-CPU-Critical" "Aurora CPU utilization is critically high" "CPUUtilization" "AWS/RDS" "90" "GreaterThanThreshold" "$SNS_TOPIC_CRITICAL"
create_alarm "${ALARM_PREFIX}-Aurora-DatabaseConnections-Critical" "Aurora database connections are high" "DatabaseConnections" "AWS/RDS" "80" "GreaterThanThreshold" "$SNS_TOPIC_CRITICAL"
create_alarm "${ALARM_PREFIX}-Aurora-FreeableMemory-Critical" "Aurora freeable memory is low" "FreeableMemory" "AWS/RDS" "104857600" "LessThanThreshold" "$SNS_TOPIC_CRITICAL"
create_alarm "${ALARM_PREFIX}-Aurora-AuroraReplicaLag-Critical" "Aurora replica lag is high" "AuroraReplicaLag" "AWS/RDS" "1000" "GreaterThanThreshold" "$SNS_TOPIC_CRITICAL"
create_alarm "${ALARM_PREFIX}-Aurora-SelectLatency-Warning" "Aurora SELECT latency is high" "SelectLatency" "AWS/RDS" "0.1" "GreaterThanThreshold" "$SNS_TOPIC_WARNING"

log_success "Aurora CloudWatch Alarms deployment completed!"