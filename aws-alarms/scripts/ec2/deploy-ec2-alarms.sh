#!/bin/bash

# Deploy EC2 CloudWatch Alarms
# Based on metrics defined in ../../README.md

set -e

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Load common functions and configuration
source "$PROJECT_ROOT/utils/common-functions.sh"
load_config

# Check if EC2 alarms are enabled
if ! is_service_enabled "EC2"; then
    log_warning "EC2 alarms are disabled in configuration"
    exit 0
fi

log_info "Deploying EC2 CloudWatch Alarms..."

# EC2 CPU Utilization - Critical
create_alarm \
    "${ALARM_PREFIX}-EC2-CPU-Critical" \
    "EC2 CPU utilization is critically high" \
    "CPUUtilization" \
    "AWS/EC2" \
    "$EC2_CPU_CRITICAL_THRESHOLD" \
    "GreaterThanThreshold" \
    "$SNS_TOPIC_CRITICAL" \
    "" \
    "Average" \
    "300" \
    "2" \
    "2"

# EC2 CPU Utilization - Warning
create_alarm \
    "${ALARM_PREFIX}-EC2-CPU-Warning" \
    "EC2 CPU utilization is high" \
    "CPUUtilization" \
    "AWS/EC2" \
    "$EC2_CPU_WARNING_THRESHOLD" \
    "GreaterThanThreshold" \
    "$SNS_TOPIC_WARNING" \
    "" \
    "Average" \
    "300" \
    "2" \
    "2"

# EC2 Status Check Failed - Critical
create_alarm \
    "${ALARM_PREFIX}-EC2-StatusCheckFailed-Critical" \
    "EC2 status check failed" \
    "StatusCheckFailed" \
    "AWS/EC2" \
    "0" \
    "GreaterThanThreshold" \
    "$SNS_TOPIC_CRITICAL" \
    "" \
    "Maximum" \
    "60" \
    "1" \
    "1"

# EC2 Status Check Failed Instance - Critical
create_alarm \
    "${ALARM_PREFIX}-EC2-StatusCheckFailedInstance-Critical" \
    "EC2 instance status check failed" \
    "StatusCheckFailed_Instance" \
    "AWS/EC2" \
    "0" \
    "GreaterThanThreshold" \
    "$SNS_TOPIC_CRITICAL" \
    "" \
    "Maximum" \
    "60" \
    "1" \
    "1"

# EC2 Status Check Failed System - Critical
create_alarm \
    "${ALARM_PREFIX}-EC2-StatusCheckFailedSystem-Critical" \
    "EC2 system status check failed" \
    "StatusCheckFailed_System" \
    "AWS/EC2" \
    "0" \
    "GreaterThanThreshold" \
    "$SNS_TOPIC_CRITICAL" \
    "" \
    "Maximum" \
    "60" \
    "1" \
    "1"

# EC2 Network In - Warning
create_alarm \
    "${ALARM_PREFIX}-EC2-NetworkIn-Warning" \
    "EC2 network input is high" \
    "NetworkIn" \
    "AWS/EC2" \
    "$EC2_NETWORK_IN_WARNING_THRESHOLD" \
    "GreaterThanThreshold" \
    "$SNS_TOPIC_WARNING" \
    "" \
    "Average" \
    "300" \
    "2" \
    "2"

# EC2 Network Out - Warning
create_alarm \
    "${ALARM_PREFIX}-EC2-NetworkOut-Warning" \
    "EC2 network output is high" \
    "NetworkOut" \
    "AWS/EC2" \
    "$EC2_NETWORK_OUT_WARNING_THRESHOLD" \
    "GreaterThanThreshold" \
    "$SNS_TOPIC_WARNING" \
    "" \
    "Average" \
    "300" \
    "2" \
    "2"

# EC2 Disk Read Ops - Warning
create_alarm \
    "${ALARM_PREFIX}-EC2-DiskReadOps-Warning" \
    "EC2 disk read operations are high" \
    "DiskReadOps" \
    "AWS/EC2" \
    "$EC2_DISK_READ_OPS_WARNING_THRESHOLD" \
    "GreaterThanThreshold" \
    "$SNS_TOPIC_WARNING" \
    "" \
    "Average" \
    "300" \
    "2" \
    "2"

# EC2 Disk Write Ops - Warning
create_alarm \
    "${ALARM_PREFIX}-EC2-DiskWriteOps-Warning" \
    "EC2 disk write operations are high" \
    "DiskWriteOps" \
    "AWS/EC2" \
    "$EC2_DISK_WRITE_OPS_WARNING_THRESHOLD" \
    "GreaterThanThreshold" \
    "$SNS_TOPIC_WARNING" \
    "" \
    "Average" \
    "300" \
    "2" \
    "2"

log_success "EC2 CloudWatch Alarms deployment completed!"
log_info "Created alarms:"
log_info "  - ${ALARM_PREFIX}-EC2-CPU-Critical"
log_info "  - ${ALARM_PREFIX}-EC2-CPU-Warning"
log_info "  - ${ALARM_PREFIX}-EC2-StatusCheckFailed-Critical"
log_info "  - ${ALARM_PREFIX}-EC2-StatusCheckFailedInstance-Critical"
log_info "  - ${ALARM_PREFIX}-EC2-StatusCheckFailedSystem-Critical"
log_info "  - ${ALARM_PREFIX}-EC2-NetworkIn-Warning"
log_info "  - ${ALARM_PREFIX}-EC2-NetworkOut-Warning"
log_info "  - ${ALARM_PREFIX}-EC2-DiskReadOps-Warning"
log_info "  - ${ALARM_PREFIX}-EC2-DiskWriteOps-Warning"