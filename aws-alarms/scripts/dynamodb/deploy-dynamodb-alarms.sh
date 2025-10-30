#!/bin/bash

# Deploy DynamoDB CloudWatch Alarms
# Based on metrics defined in ../../README.md

set -e

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Load common functions and configuration
source "$PROJECT_ROOT/utils/common-functions.sh"
load_config

# Check if DynamoDB alarms are enabled
if ! is_service_enabled "DYNAMODB"; then
    log_warning "DynamoDB alarms are disabled in configuration"
    exit 0
fi

log_info "Deploying DynamoDB CloudWatch Alarms..."

# DynamoDB Throttled Requests - Critical
create_alarm \
    "${ALARM_PREFIX}-DynamoDB-ThrottledRequests-Critical" \
    "DynamoDB table has throttled requests" \
    "ThrottledRequests" \
    "AWS/DynamoDB" \
    "$DYNAMODB_THROTTLED_REQUESTS_THRESHOLD" \
    "GreaterThanThreshold" \
    "$SNS_TOPIC_CRITICAL" \
    "" \
    "Sum" \
    "300" \
    "1" \
    "1"

# DynamoDB System Errors - Critical
create_alarm \
    "${ALARM_PREFIX}-DynamoDB-SystemErrors-Critical" \
    "DynamoDB table has system errors" \
    "SystemErrors" \
    "AWS/DynamoDB" \
    "$DYNAMODB_SYSTEM_ERRORS_THRESHOLD" \
    "GreaterThanThreshold" \
    "$SNS_TOPIC_CRITICAL" \
    "" \
    "Sum" \
    "300" \
    "1" \
    "1"

# DynamoDB Consumed Read Capacity - Warning
aws cloudwatch put-metric-alarm \
    --alarm-name "${ALARM_PREFIX}-DynamoDB-ConsumedReadCapacity-Warning" \
    --alarm-description "DynamoDB consumed read capacity is high" \
    --metrics '[
        {
            "Id": "consumed_read",
            "ReturnData": false,
            "MetricStat": {
                "Metric": {
                    "Namespace": "AWS/DynamoDB",
                    "MetricName": "ConsumedReadCapacityUnits"
                },
                "Period": 300,
                "Stat": "Sum"
            }
        },
        {
            "Id": "provisioned_read", 
            "ReturnData": false,
            "MetricStat": {
                "Metric": {
                    "Namespace": "AWS/DynamoDB",
                    "MetricName": "ProvisionedReadCapacityUnits"
                },
                "Period": 300,
                "Stat": "Average"
            }
        },
        {
            "Id": "read_capacity_utilization",
            "Expression": "consumed_read/(provisioned_read*300)*100",
            "ReturnData": true
        }
    ]' \
    --threshold "$DYNAMODB_READ_CAPACITY_CRITICAL_THRESHOLD" \
    --comparison-operator "GreaterThanThreshold" \
    --evaluation-periods 2 \
    --datapoints-to-alarm 2 \
    --alarm-actions "$SNS_TOPIC_WARNING" \
    --treat-missing-data "$TREAT_MISSING_DATA" \
    --profile "$AWS_PROFILE" --region "$AWS_REGION"

# DynamoDB Consumed Write Capacity - Warning
aws cloudwatch put-metric-alarm \
    --alarm-name "${ALARM_PREFIX}-DynamoDB-ConsumedWriteCapacity-Warning" \
    --alarm-description "DynamoDB consumed write capacity is high" \
    --metrics '[
        {
            "Id": "consumed_write",
            "ReturnData": false,
            "MetricStat": {
                "Metric": {
                    "Namespace": "AWS/DynamoDB",
                    "MetricName": "ConsumedWriteCapacityUnits"
                },
                "Period": 300,
                "Stat": "Sum"
            }
        },
        {
            "Id": "provisioned_write", 
            "ReturnData": false,
            "MetricStat": {
                "Metric": {
                    "Namespace": "AWS/DynamoDB",
                    "MetricName": "ProvisionedWriteCapacityUnits"
                },
                "Period": 300,
                "Stat": "Average"
            }
        },
        {
            "Id": "write_capacity_utilization",
            "Expression": "consumed_write/(provisioned_write*300)*100",
            "ReturnData": true
        }
    ]' \
    --threshold "$DYNAMODB_WRITE_CAPACITY_CRITICAL_THRESHOLD" \
    --comparison-operator "GreaterThanThreshold" \
    --evaluation-periods 2 \
    --datapoints-to-alarm 2 \
    --alarm-actions "$SNS_TOPIC_WARNING" \
    --treat-missing-data "$TREAT_MISSING_DATA" \
    --profile "$AWS_PROFILE" --region "$AWS_REGION"

# DynamoDB Successful Request Latency - Warning
create_alarm \
    "${ALARM_PREFIX}-DynamoDB-SuccessfulRequestLatency-Warning" \
    "DynamoDB request latency is high" \
    "SuccessfulRequestLatency" \
    "AWS/DynamoDB" \
    "100" \
    "GreaterThanThreshold" \
    "$SNS_TOPIC_WARNING" \
    "" \
    "Average" \
    "300" \
    "2" \
    "2"

# DynamoDB Item Count - Warning
create_alarm \
    "${ALARM_PREFIX}-DynamoDB-ItemCount-Warning" \
    "DynamoDB item count is high" \
    "ItemCount" \
    "AWS/DynamoDB" \
    "$DYNAMODB_ITEM_COUNT_WARNING_THRESHOLD" \
    "GreaterThanThreshold" \
    "$SNS_TOPIC_WARNING" \
    "" \
    "Average" \
    "300" \
    "2" \
    "2"

log_success "DynamoDB CloudWatch Alarms deployment completed!"
log_info "Created alarms:"
log_info "  - ${ALARM_PREFIX}-DynamoDB-ThrottledRequests-Critical"
log_info "  - ${ALARM_PREFIX}-DynamoDB-SystemErrors-Critical"
log_info "  - ${ALARM_PREFIX}-DynamoDB-ConsumedReadCapacity-Warning"
log_info "  - ${ALARM_PREFIX}-DynamoDB-ConsumedWriteCapacity-Warning"
log_info "  - ${ALARM_PREFIX}-DynamoDB-SuccessfulRequestLatency-Warning"
log_info "  - ${ALARM_PREFIX}-DynamoDB-ItemCount-Warning"