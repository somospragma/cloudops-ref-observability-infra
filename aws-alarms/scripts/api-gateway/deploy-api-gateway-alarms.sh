#!/bin/bash

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
source "$PROJECT_ROOT/utils/common-functions.sh"
load_config

if ! is_service_enabled "API_GATEWAY"; then
    log_warning "API Gateway alarms are disabled in configuration"
    exit 0
fi

log_info "Deploying API Gateway CloudWatch Alarms..."

aws cloudwatch put-metric-alarm \
    --alarm-name "${ALARM_PREFIX}-APIGateway-4xxErrorRate-Critical" \
    --alarm-description "API Gateway 4xx error rate is critically high" \
    --metrics '[
        {
            "Id": "e4xx",
            "ReturnData": false,
            "MetricStat": {
                "Metric": {
                    "Namespace": "AWS/ApiGateway",
                    "MetricName": "4XXError"
                },
                "Period": 300,
                "Stat": "Sum"
            }
        },
        {
            "Id": "count", 
            "ReturnData": false,
            "MetricStat": {
                "Metric": {
                    "Namespace": "AWS/ApiGateway",
                    "MetricName": "Count"
                },
                "Period": 300,
                "Stat": "Sum"
            }
        },
        {
            "Id": "error_rate_4xx",
            "Expression": "e4xx/count*100",
            "ReturnData": true
        }
    ]' \
    --threshold "$API_GATEWAY_4XX_ERROR_RATE_CRITICAL_THRESHOLD" \
    --comparison-operator "GreaterThanThreshold" \
    --evaluation-periods 2 \
    --alarm-actions "$SNS_TOPIC_CRITICAL" \
    --profile "$AWS_PROFILE" --region "$AWS_REGION"

create_alarm \
    "${ALARM_PREFIX}-APIGateway-5XXError-Critical" \
    "API Gateway 5xx errors are high" \
    "5XXError" \
    "AWS/ApiGateway" \
    "$API_GATEWAY_5XX_ERROR_RATE_CRITICAL_THRESHOLD" \
    "GreaterThanThreshold" \
    "$SNS_TOPIC_CRITICAL" \
    "" \
    "Sum"

create_alarm \
    "${ALARM_PREFIX}-APIGateway-IntegrationLatency-Warning" \
    "API Gateway integration latency is high" \
    "IntegrationLatency" \
    "AWS/ApiGateway" \
    "29000" \
    "GreaterThanThreshold" \
    "$SNS_TOPIC_WARNING" \
    "" \
    "Average"

create_alarm \
    "${ALARM_PREFIX}-APIGateway-Latency-Warning" \
    "API Gateway latency is high" \
    "Latency" \
    "AWS/ApiGateway" \
    "29000" \
    "GreaterThanThreshold" \
    "$SNS_TOPIC_WARNING" \
    "" \
    "Average"

aws cloudwatch put-anomaly-detector \
    --namespace "AWS/ApiGateway" \
    --metric-name "Count" \
    --stat "Sum" \
    --profile "$AWS_PROFILE" --region "$AWS_REGION"

log_success "API Gateway CloudWatch Alarms deployment completed!"