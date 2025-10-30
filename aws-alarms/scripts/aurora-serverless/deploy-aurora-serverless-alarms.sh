#!/bin/bash

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
source "$PROJECT_ROOT/utils/common-functions.sh"
load_config

if ! is_service_enabled "AURORA_SERVERLESS"; then
    log_warning "Aurora Serverless alarms are disabled in configuration"
    exit 0
fi

log_info "Deploying Aurora Serverless CloudWatch Alarms..."

create_alarm "${ALARM_PREFIX}-AuroraServerless-DatabaseCapacity-Critical" "Aurora Serverless capacity is high" "ServerlessDatabaseCapacity" "AWS/RDS" "90" "GreaterThanThreshold" "$SNS_TOPIC_CRITICAL"
create_alarm "${ALARM_PREFIX}-AuroraServerless-ACUUtilization-Critical" "Aurora Serverless ACU utilization is high" "ACUUtilization" "AWS/RDS" "90" "GreaterThanThreshold" "$SNS_TOPIC_CRITICAL"
create_alarm "${ALARM_PREFIX}-AuroraServerless-DatabaseConnections-Critical" "Aurora Serverless connections are high" "DatabaseConnections" "AWS/RDS" "80" "GreaterThanThreshold" "$SNS_TOPIC_CRITICAL"

log_success "Aurora Serverless CloudWatch Alarms deployment completed!"