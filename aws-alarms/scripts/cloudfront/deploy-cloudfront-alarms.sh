#!/bin/bash

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
source "$PROJECT_ROOT/utils/common-functions.sh"
load_config

if ! is_service_enabled "CLOUDFRONT"; then
    log_warning "CloudFront alarms are disabled in configuration"
    exit 0
fi

log_info "Deploying CloudFront CloudWatch Alarms..."

# CloudFront 4xx Error Rate - Critical
aws cloudwatch put-metric-alarm \
    --alarm-name "${ALARM_PREFIX}-CloudFront-4xxErrorRate-Critical" \
    --alarm-description "CloudFront 4xx error rate is critically high" \
    --metrics '[
        {
            "Id": "e4xx",
            "ReturnData": false,
            "MetricStat": {
                "Metric": {
                    "Namespace": "AWS/CloudFront",
                    "MetricName": "4xxErrorRate"
                },
                "Period": 300,
                "Stat": "Average"
            }
        },
        {
            "Id": "error_rate_4xx",
            "Expression": "e4xx",
            "ReturnData": true
        }
    ]' \
    --threshold "$CLOUDFRONT_4XX_ERROR_RATE_CRITICAL_THRESHOLD" \
    --comparison-operator "GreaterThanThreshold" \
    --evaluation-periods 2 \
    --alarm-actions "$SNS_TOPIC_CRITICAL" \
    --profile "$AWS_PROFILE" --region "$AWS_REGION"

# CloudFront 5xx Error Rate - Critical
create_alarm \
    "${ALARM_PREFIX}-CloudFront-5xxErrorRate-Critical" \
    "CloudFront 5xx error rate is critically high" \
    "5xxErrorRate" \
    "AWS/CloudFront" \
    "$CLOUDFRONT_5XX_ERROR_RATE_CRITICAL_THRESHOLD" \
    "GreaterThanThreshold" \
    "$SNS_TOPIC_CRITICAL"

# CloudFront Origin Latency - Warning
create_alarm \
    "${ALARM_PREFIX}-CloudFront-OriginLatency-Warning" \
    "CloudFront origin latency is high" \
    "OriginLatency" \
    "AWS/CloudFront" \
    "30000" \
    "GreaterThanThreshold" \
    "$SNS_TOPIC_WARNING"

# CloudFront Cache Hit Rate - Warning
create_alarm \
    "${ALARM_PREFIX}-CloudFront-CacheHitRate-Warning" \
    "CloudFront cache hit rate is low" \
    "CacheHitRate" \
    "AWS/CloudFront" \
    "80" \
    "LessThanThreshold" \
    "$SNS_TOPIC_WARNING"

# CloudFront Requests - Warning
create_alarm \
    "${ALARM_PREFIX}-CloudFront-Requests-Warning" \
    "CloudFront requests volume is high" \
    "Requests" \
    "AWS/CloudFront" \
    "$CLOUDFRONT_REQUESTS_WARNING_THRESHOLD" \
    "GreaterThanThreshold" \
    "$SNS_TOPIC_WARNING" \
    "" \
    "Sum" \
    "300" \
    "2" \
    "2"

log_success "CloudFront CloudWatch Alarms deployment completed!"
log_info "Created alarms:"
log_info "  - ${ALARM_PREFIX}-CloudFront-4xxErrorRate-Critical"
log_info "  - ${ALARM_PREFIX}-CloudFront-5xxErrorRate-Critical"
log_info "  - ${ALARM_PREFIX}-CloudFront-OriginLatency-Warning"
log_info "  - ${ALARM_PREFIX}-CloudFront-CacheHitRate-Warning"
log_info "  - ${ALARM_PREFIX}-CloudFront-Requests-Warning"