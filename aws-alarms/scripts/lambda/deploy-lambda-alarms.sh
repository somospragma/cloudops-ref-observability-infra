#!/bin/bash

# Deploy Lambda CloudWatch Alarms
# Based on metrics defined in ../../README.md

set -e

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Load common functions and configuration
source "$PROJECT_ROOT/utils/common-functions.sh"
load_config

# Check if Lambda alarms are enabled
if ! is_service_enabled "LAMBDA"; then
    log_warning "Lambda alarms are disabled in configuration"
    exit 0
fi

log_info "Deploying Lambda CloudWatch Alarms..."

# Lambda Errors - Critical (Error Rate)
# Note: This creates a composite alarm using math expressions
aws cloudwatch put-metric-alarm \
    --alarm-name "${ALARM_PREFIX}-Lambda-ErrorRate-Critical" \
    --alarm-description "Lambda error rate is critically high" \
    --metrics '[
        {
            "Id": "e1",
            "ReturnData": false,
            "MetricStat": {
                "Metric": {
                    "Namespace": "AWS/Lambda",
                    "MetricName": "Errors"
                },
                "Period": 300,
                "Stat": "Sum"
            }
        },
        {
            "Id": "i1", 
            "ReturnData": false,
            "MetricStat": {
                "Metric": {
                    "Namespace": "AWS/Lambda",
                    "MetricName": "Invocations"
                },
                "Period": 300,
                "Stat": "Sum"
            }
        },
        {
            "Id": "error_rate",
            "Expression": "e1/i1*100",
            "ReturnData": true
        }
    ]' \
    --threshold "$LAMBDA_ERROR_RATE_CRITICAL_THRESHOLD" \
    --comparison-operator "GreaterThanThreshold" \
    --evaluation-periods 2 \
    --datapoints-to-alarm 2 \
    --alarm-actions "$SNS_TOPIC_CRITICAL" \
    --treat-missing-data "$TREAT_MISSING_DATA" \
    --profile "$AWS_PROFILE" \
    --region "$AWS_REGION"

# Lambda Throttles - Critical
create_alarm \
    "${ALARM_PREFIX}-Lambda-Throttles-Critical" \
    "Lambda function is being throttled" \
    "Throttles" \
    "AWS/Lambda" \
    "0" \
    "GreaterThanThreshold" \
    "$SNS_TOPIC_CRITICAL" \
    "" \
    "Sum" \
    "300" \
    "1" \
    "1"

# Lambda Duration - Warning
create_alarm \
    "${ALARM_PREFIX}-Lambda-Duration-Warning" \
    "Lambda function duration is high" \
    "Duration" \
    "AWS/Lambda" \
    "$LAMBDA_DURATION_CRITICAL_THRESHOLD" \
    "GreaterThanThreshold" \
    "$SNS_TOPIC_WARNING" \
    "" \
    "Average" \
    "300" \
    "2" \
    "2"

# Lambda Concurrent Executions - Warning
create_alarm \
    "${ALARM_PREFIX}-Lambda-ConcurrentExecutions-Warning" \
    "Lambda concurrent executions are high" \
    "ConcurrentExecutions" \
    "AWS/Lambda" \
    "800" \
    "GreaterThanThreshold" \
    "$SNS_TOPIC_WARNING" \
    "" \
    "Maximum" \
    "300" \
    "2" \
    "2"

# Lambda Iterator Age - Warning (for stream-based invocations)
create_alarm \
    "${ALARM_PREFIX}-Lambda-IteratorAge-Warning" \
    "Lambda iterator age is high" \
    "IteratorAge" \
    "AWS/Lambda" \
    "60000" \
    "GreaterThanThreshold" \
    "$SNS_TOPIC_WARNING" \
    "" \
    "Maximum" \
    "300" \
    "2" \
    "2"

# Lambda Dead Letter Errors - Critical
create_alarm \
    "${ALARM_PREFIX}-Lambda-DeadLetterErrors-Critical" \
    "Lambda function has dead letter queue errors" \
    "DeadLetterErrors" \
    "AWS/Lambda" \
    "0" \
    "GreaterThanThreshold" \
    "$SNS_TOPIC_CRITICAL" \
    "" \
    "Sum" \
    "300" \
    "1" \
    "1"

# Lambda Invocations - Warning
create_alarm \
    "${ALARM_PREFIX}-Lambda-Invocations-Warning" \
    "Lambda invocations volume is high" \
    "Invocations" \
    "AWS/Lambda" \
    "$LAMBDA_INVOCATIONS_WARNING_THRESHOLD" \
    "GreaterThanThreshold" \
    "$SNS_TOPIC_WARNING" \
    "" \
    "Sum" \
    "300" \
    "2" \
    "2"

log_success "Lambda CloudWatch Alarms deployment completed!"
log_info "Created alarms:"
log_info "  - ${ALARM_PREFIX}-Lambda-ErrorRate-Critical"
log_info "  - ${ALARM_PREFIX}-Lambda-Throttles-Critical"
log_info "  - ${ALARM_PREFIX}-Lambda-Duration-Warning"
log_info "  - ${ALARM_PREFIX}-Lambda-ConcurrentExecutions-Warning"
log_info "  - ${ALARM_PREFIX}-Lambda-IteratorAge-Warning"
log_info "  - ${ALARM_PREFIX}-Lambda-DeadLetterErrors-Critical"
log_info "  - ${ALARM_PREFIX}-Lambda-Invocations-Warning"