#!/bin/bash

# Deploy RDS CloudWatch Alarms
# Based on metrics defined in ../../README.md

set -e

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Load common functions and configuration
source "$PROJECT_ROOT/utils/common-functions.sh"
load_config

# Check if RDS alarms are enabled
if ! is_service_enabled "RDS"; then
    log_warning "RDS alarms are disabled in configuration"
    exit 0
fi

log_info "Deploying RDS CloudWatch Alarms..."

# RDS CPU Utilization - Critical
create_alarm \
    "${ALARM_PREFIX}-RDS-CPU-Critical" \
    "RDS CPU utilization is critically high" \
    "CPUUtilization" \
    "AWS/RDS" \
    "$RDS_CPU_CRITICAL_THRESHOLD" \
    "GreaterThanThreshold" \
    "$SNS_TOPIC_CRITICAL" \
    "" \
    "Average" \
    "300" \
    "2" \
    "2"

# RDS CPU Utilization - Warning
create_alarm \
    "${ALARM_PREFIX}-RDS-CPU-Warning" \
    "RDS CPU utilization is high" \
    "CPUUtilization" \
    "AWS/RDS" \
    "$RDS_CPU_WARNING_THRESHOLD" \
    "GreaterThanThreshold" \
    "$SNS_TOPIC_WARNING" \
    "" \
    "Average" \
    "300" \
    "2" \
    "2"

# RDS Database Connections - Critical
create_alarm \
    "${ALARM_PREFIX}-RDS-DatabaseConnections-Critical" \
    "RDS database connections are critically high" \
    "DatabaseConnections" \
    "AWS/RDS" \
    "$RDS_CONNECTIONS_CRITICAL_THRESHOLD" \
    "GreaterThanThreshold" \
    "$SNS_TOPIC_CRITICAL" \
    "" \
    "Average" \
    "300" \
    "2" \
    "2"

# RDS Freeable Memory - Critical
create_alarm \
    "${ALARM_PREFIX}-RDS-FreeableMemory-Critical" \
    "RDS freeable memory is critically low" \
    "FreeableMemory" \
    "AWS/RDS" \
    "$RDS_FREEABLE_MEMORY_CRITICAL_THRESHOLD" \
    "LessThanThreshold" \
    "$SNS_TOPIC_CRITICAL" \
    "" \
    "Average" \
    "300" \
    "2" \
    "2"

# RDS Free Storage Space - Critical
create_alarm \
    "${ALARM_PREFIX}-RDS-FreeStorageSpace-Critical" \
    "RDS free storage space is critically low" \
    "FreeStorageSpace" \
    "AWS/RDS" \
    "2000000000" \
    "LessThanThreshold" \
    "$SNS_TOPIC_CRITICAL" \
    "" \
    "Average" \
    "300" \
    "1" \
    "1"

# RDS Read Latency - Warning
create_alarm \
    "${ALARM_PREFIX}-RDS-ReadLatency-Warning" \
    "RDS read latency is high" \
    "ReadLatency" \
    "AWS/RDS" \
    "0.2" \
    "GreaterThanThreshold" \
    "$SNS_TOPIC_WARNING" \
    "" \
    "Average" \
    "300" \
    "2" \
    "2"

# RDS Write Latency - Warning
create_alarm \
    "${ALARM_PREFIX}-RDS-WriteLatency-Warning" \
    "RDS write latency is high" \
    "WriteLatency" \
    "AWS/RDS" \
    "0.2" \
    "GreaterThanThreshold" \
    "$SNS_TOPIC_WARNING" \
    "" \
    "Average" \
    "300" \
    "2" \
    "2"

# RDS Replica Lag - Critical
create_alarm \
    "${ALARM_PREFIX}-RDS-ReplicaLag-Critical" \
    "RDS replica lag is critically high" \
    "ReplicaLag" \
    "AWS/RDS" \
    "300" \
    "GreaterThanThreshold" \
    "$SNS_TOPIC_CRITICAL" \
    "" \
    "Average" \
    "300" \
    "2" \
    "2"

log_success "RDS CloudWatch Alarms deployment completed!"
log_info "Created alarms:"
log_info "  - ${ALARM_PREFIX}-RDS-CPU-Critical"
log_info "  - ${ALARM_PREFIX}-RDS-CPU-Warning"
log_info "  - ${ALARM_PREFIX}-RDS-DatabaseConnections-Critical"
log_info "  - ${ALARM_PREFIX}-RDS-FreeableMemory-Critical"
log_info "  - ${ALARM_PREFIX}-RDS-FreeStorageSpace-Critical"
log_info "  - ${ALARM_PREFIX}-RDS-ReadLatency-Warning"
log_info "  - ${ALARM_PREFIX}-RDS-WriteLatency-Warning"
log_info "  - ${ALARM_PREFIX}-RDS-ReplicaLag-Critical"