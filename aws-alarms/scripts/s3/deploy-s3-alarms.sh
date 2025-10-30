#!/bin/bash

# Deploy S3 CloudWatch Alarms
# Based on metrics defined in ../../README.md

set -e

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Load common functions and configuration
source "$PROJECT_ROOT/utils/common-functions.sh"
load_config

# Check if S3 alarms are enabled
if ! is_service_enabled "S3"; then
    log_warning "S3 alarms are disabled in configuration"
    exit 0
fi

log_info "Deploying S3 CloudWatch Alarms..."

# S3 4xx Error Rate - Critical
aws cloudwatch put-metric-alarm \
    --alarm-name "${ALARM_PREFIX}-S3-4xxErrorRate-Critical" \
    --alarm-description "S3 4xx error rate is critically high" \
    --metrics '[
        {
            "Id": "e4xx",
            "ReturnData": false,
            "MetricStat": {
                "Metric": {
                    "Namespace": "AWS/S3",
                    "MetricName": "4xxErrors"
                },
                "Period": 300,
                "Stat": "Sum"
            }
        },
        {
            "Id": "requests", 
            "ReturnData": false,
            "MetricStat": {
                "Metric": {
                    "Namespace": "AWS/S3",
                    "MetricName": "AllRequests"
                },
                "Period": 300,
                "Stat": "Sum"
            }
        },
        {
            "Id": "error_rate_4xx",
            "Expression": "e4xx/requests*100",
            "ReturnData": true
        }
    ]' \
    --threshold "$S3_4XX_ERROR_RATE_CRITICAL_THRESHOLD" \
    --comparison-operator "GreaterThanThreshold" \
    --evaluation-periods 2 \
    --datapoints-to-alarm 2 \
    --alarm-actions "$SNS_TOPIC_CRITICAL" \
    --treat-missing-data "$TREAT_MISSING_DATA" \
    --profile "$AWS_PROFILE" \
    --region "$AWS_REGION"

# S3 5xx Error Rate - Critical
aws cloudwatch put-metric-alarm \
    --alarm-name "${ALARM_PREFIX}-S3-5xxErrorRate-Critical" \
    --alarm-description "S3 5xx error rate is critically high" \
    --metrics '[
        {
            "Id": "e5xx",
            "ReturnData": false,
            "MetricStat": {
                "Metric": {
                    "Namespace": "AWS/S3",
                    "MetricName": "5xxErrors"
                },
                "Period": 300,
                "Stat": "Sum"
            }
        },
        {
            "Id": "requests", 
            "ReturnData": false,
            "MetricStat": {
                "Metric": {
                    "Namespace": "AWS/S3",
                    "MetricName": "AllRequests"
                },
                "Period": 300,
                "Stat": "Sum"
            }
        },
        {
            "Id": "error_rate_5xx",
            "Expression": "e5xx/requests*100",
            "ReturnData": true
        }
    ]' \
    --threshold "$S3_5XX_ERROR_RATE_CRITICAL_THRESHOLD" \
    --comparison-operator "GreaterThanThreshold" \
    --evaluation-periods 2 \
    --datapoints-to-alarm 2 \
    --alarm-actions "$SNS_TOPIC_CRITICAL" \
    --treat-missing-data "$TREAT_MISSING_DATA" \
    --profile "$AWS_PROFILE" \
    --region "$AWS_REGION"

# S3 First Byte Latency - Warning
create_alarm \
    "${ALARM_PREFIX}-S3-FirstByteLatency-Warning" \
    "S3 first byte latency is high" \
    "FirstByteLatency" \
    "AWS/S3" \
    "1000" \
    "GreaterThanThreshold" \
    "$SNS_TOPIC_WARNING" \
    "" \
    "Average" \
    "300" \
    "2" \
    "2"

# S3 Total Request Latency - Warning
create_alarm \
    "${ALARM_PREFIX}-S3-TotalRequestLatency-Warning" \
    "S3 total request latency is high" \
    "TotalRequestLatency" \
    "AWS/S3" \
    "5000" \
    "GreaterThanThreshold" \
    "$SNS_TOPIC_WARNING" \
    "" \
    "Average" \
    "300" \
    "2" \
    "2"

# S3 All Requests - Warning
create_alarm \
    "${ALARM_PREFIX}-S3-AllRequests-Warning" \
    "S3 all requests volume is high" \
    "AllRequests" \
    "AWS/S3" \
    "$S3_ALL_REQUESTS_WARNING_THRESHOLD" \
    "GreaterThanThreshold" \
    "$SNS_TOPIC_WARNING" \
    "" \
    "Sum" \
    "300" \
    "2" \
    "2"

# S3 GET Requests - Warning
create_alarm \
    "${ALARM_PREFIX}-S3-GetRequests-Warning" \
    "S3 GET requests volume is high" \
    "GetRequests" \
    "AWS/S3" \
    "$S3_GET_REQUESTS_WARNING_THRESHOLD" \
    "GreaterThanThreshold" \
    "$SNS_TOPIC_WARNING" \
    "" \
    "Sum" \
    "300" \
    "2" \
    "2"

# S3 PUT Requests - Warning
create_alarm \
    "${ALARM_PREFIX}-S3-PutRequests-Warning" \
    "S3 PUT requests volume is high" \
    "PutRequests" \
    "AWS/S3" \
    "$S3_PUT_REQUESTS_WARNING_THRESHOLD" \
    "GreaterThanThreshold" \
    "$SNS_TOPIC_WARNING" \
    "" \
    "Sum" \
    "300" \
    "2" \
    "2"

# S3 DELETE Requests - Warning
create_alarm \
    "${ALARM_PREFIX}-S3-DeleteRequests-Warning" \
    "S3 DELETE requests volume is high" \
    "DeleteRequests" \
    "AWS/S3" \
    "$S3_DELETE_REQUESTS_WARNING_THRESHOLD" \
    "GreaterThanThreshold" \
    "$SNS_TOPIC_WARNING" \
    "" \
    "Sum" \
    "300" \
    "2" \
    "2"

log_success "S3 CloudWatch Alarms deployment completed!"
log_info "Created alarms:"
log_info "  - ${ALARM_PREFIX}-S3-4xxErrorRate-Critical"
log_info "  - ${ALARM_PREFIX}-S3-5xxErrorRate-Critical"
log_info "  - ${ALARM_PREFIX}-S3-FirstByteLatency-Warning"
log_info "  - ${ALARM_PREFIX}-S3-TotalRequestLatency-Warning"
log_info "  - ${ALARM_PREFIX}-S3-AllRequests-Warning"
log_info "  - ${ALARM_PREFIX}-S3-GetRequests-Warning"
log_info "  - ${ALARM_PREFIX}-S3-PutRequests-Warning"
log_info "  - ${ALARM_PREFIX}-S3-DeleteRequests-Warning"