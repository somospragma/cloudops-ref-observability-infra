#!/bin/bash

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
source "$PROJECT_ROOT/utils/common-functions.sh"
load_config

if ! is_service_enabled "ALB"; then
    log_warning "ALB alarms are disabled in configuration"
    exit 0
fi

log_info "Deploying ALB CloudWatch Alarms..."

create_alarm \
    "${ALARM_PREFIX}-ALB-HTTPCode-ELB-5XX-Critical" \
    "ALB 5xx errors from ELB are high" \
    "HTTPCode_ELB_5XX_Count" \
    "AWS/ApplicationELB" \
    "$ALB_5XX_ERROR_COUNT_CRITICAL_THRESHOLD" \
    "GreaterThanThreshold" \
    "$SNS_TOPIC_CRITICAL" \
    "" \
    "Sum"

create_alarm \
    "${ALARM_PREFIX}-ALB-HTTPCode-Target-5XX-Critical" \
    "ALB 5xx errors from targets are high" \
    "HTTPCode_Target_5XX_Count" \
    "AWS/ApplicationELB" \
    "$ALB_5XX_ERROR_COUNT_CRITICAL_THRESHOLD" \
    "GreaterThanThreshold" \
    "$SNS_TOPIC_CRITICAL" \
    "" \
    "Sum"

create_alarm \
    "${ALARM_PREFIX}-ALB-UnHealthyHostCount-Critical" \
    "ALB has unhealthy hosts" \
    "UnHealthyHostCount" \
    "AWS/ApplicationELB" \
    "0" \
    "GreaterThanThreshold" \
    "$SNS_TOPIC_CRITICAL" \
    "" \
    "Average"

create_alarm \
    "${ALARM_PREFIX}-ALB-TargetResponseTime-Warning" \
    "ALB target response time is high" \
    "TargetResponseTime" \
    "AWS/ApplicationELB" \
    "$ALB_RESPONSE_TIME_CRITICAL_THRESHOLD" \
    "GreaterThanThreshold" \
    "$SNS_TOPIC_WARNING" \
    "" \
    "Average"

# ALB Request Count - Warning
create_alarm \
    "${ALARM_PREFIX}-ALB-RequestCount-Warning" \
    "ALB request count is high" \
    "RequestCount" \
    "AWS/ApplicationELB" \
    "$ALB_REQUEST_COUNT_WARNING_THRESHOLD" \
    "GreaterThanThreshold" \
    "$SNS_TOPIC_WARNING" \
    "" \
    "Sum" \
    "300" \
    "2" \
    "2"

log_success "ALB CloudWatch Alarms deployment completed!"
log_info "Created alarms:"
log_info "  - ${ALARM_PREFIX}-ALB-HTTPCode-ELB-5XX-Critical"
log_info "  - ${ALARM_PREFIX}-ALB-HTTPCode-Target-5XX-Critical"
log_info "  - ${ALARM_PREFIX}-ALB-UnHealthyHostCount-Critical"
log_info "  - ${ALARM_PREFIX}-ALB-TargetResponseTime-Warning"
log_info "  - ${ALARM_PREFIX}-ALB-RequestCount-Warning"