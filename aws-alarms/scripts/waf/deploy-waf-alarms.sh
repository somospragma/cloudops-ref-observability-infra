#!/bin/bash

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
source "$PROJECT_ROOT/utils/common-functions.sh"
load_config

if ! is_service_enabled "WAF"; then
    log_warning "WAF alarms are disabled in configuration"
    exit 0
fi

log_info "Deploying WAF CloudWatch Alarms..."

aws cloudwatch put-metric-alarm \
    --alarm-name "${ALARM_PREFIX}-WAF-BlockedRequestsRate-Critical" \
    --alarm-description "WAF blocked requests rate is high" \
    --metrics '[
        {
            "Id": "blocked",
            "ReturnData": false,
            "MetricStat": {
                "Metric": {
                    "Namespace": "AWS/WAFV2",
                    "MetricName": "BlockedRequests"
                },
                "Period": 300,
                "Stat": "Sum"
            }
        },
        {
            "Id": "allowed", 
            "ReturnData": false,
            "MetricStat": {
                "Metric": {
                    "Namespace": "AWS/WAFV2",
                    "MetricName": "AllowedRequests"
                },
                "Period": 300,
                "Stat": "Sum"
            }
        },
        {
            "Id": "blocked_rate",
            "Expression": "blocked/(blocked+allowed)*100",
            "ReturnData": true
        }
    ]' \
    --threshold "50" \
    --comparison-operator "GreaterThanThreshold" \
    --evaluation-periods 2 \
    --alarm-actions "$SNS_TOPIC_CRITICAL" \
    --profile "$AWS_PROFILE" --region "$AWS_REGION"

aws cloudwatch put-anomaly-detector --namespace "AWS/WAFV2" --metric-name "AllowedRequests" --stat "Sum" --profile "$AWS_PROFILE" --region "$AWS_REGION"
aws cloudwatch put-anomaly-detector --namespace "AWS/WAFV2" --metric-name "CountedRequests" --stat "Sum" --profile "$AWS_PROFILE" --region "$AWS_REGION"

log_success "WAF CloudWatch Alarms deployment completed!"