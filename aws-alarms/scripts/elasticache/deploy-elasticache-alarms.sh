#!/bin/bash

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
source "$PROJECT_ROOT/utils/common-functions.sh"
load_config

if ! is_service_enabled "ELASTICACHE"; then
    log_warning "ElastiCache alarms are disabled in configuration"
    exit 0
fi

log_info "Deploying ElastiCache CloudWatch Alarms..."

create_alarm \
    "${ALARM_PREFIX}-ElastiCache-CPU-Critical" \
    "ElastiCache CPU utilization is critically high" \
    "CPUUtilization" \
    "AWS/ElastiCache" \
    "$ELASTICACHE_CPU_CRITICAL_THRESHOLD" \
    "GreaterThanThreshold" \
    "$SNS_TOPIC_CRITICAL"

create_alarm \
    "${ALARM_PREFIX}-ElastiCache-SwapUsage-Critical" \
    "ElastiCache swap usage is high" \
    "SwapUsage" \
    "AWS/ElastiCache" \
    "52428800" \
    "GreaterThanThreshold" \
    "$SNS_TOPIC_CRITICAL"

create_alarm \
    "${ALARM_PREFIX}-ElastiCache-Evictions-Critical" \
    "ElastiCache evictions are high" \
    "Evictions" \
    "AWS/ElastiCache" \
    "100" \
    "GreaterThanThreshold" \
    "$SNS_TOPIC_CRITICAL" \
    "" \
    "Sum"

create_alarm \
    "${ALARM_PREFIX}-ElastiCache-DatabaseMemoryUsage-Warning" \
    "ElastiCache memory usage is high" \
    "DatabaseMemoryUsagePercentage" \
    "AWS/ElastiCache" \
    "$ELASTICACHE_MEMORY_CRITICAL_THRESHOLD" \
    "GreaterThanThreshold" \
    "$SNS_TOPIC_WARNING"

create_alarm \
    "${ALARM_PREFIX}-ElastiCache-CurrConnections-Warning" \
    "ElastiCache current connections are high" \
    "CurrConnections" \
    "AWS/ElastiCache" \
    "800" \
    "GreaterThanThreshold" \
    "$SNS_TOPIC_WARNING"

log_success "ElastiCache CloudWatch Alarms deployment completed!"