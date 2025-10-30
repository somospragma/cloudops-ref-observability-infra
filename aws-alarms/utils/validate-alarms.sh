#!/bin/bash

# Validate CloudWatch Alarms
# Check for alarms with insufficient data and provide recommendations

set -e

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Load common functions and configuration
source "$PROJECT_ROOT/utils/common-functions.sh"
load_config

log_info "Validating CloudWatch Alarms..."

# Get alarms with insufficient data
INSUFFICIENT_DATA_ALARMS=$(aws cloudwatch describe-alarms \
    --alarm-name-prefix "$ALARM_PREFIX" \
    --profile "$AWS_PROFILE" \
    --region "$AWS_REGION" \
    --query 'MetricAlarms[?StateValue==`INSUFFICIENT_DATA`].AlarmName' \
    --output text)

if [[ -z "$INSUFFICIENT_DATA_ALARMS" ]]; then
    log_success "All alarms have sufficient data!"
    exit 0
fi

log_warning "Found alarms with insufficient data:"
echo "$INSUFFICIENT_DATA_ALARMS" | tr '\t' '\n' | while read -r alarm_name; do
    if [[ -n "$alarm_name" ]]; then
        echo "  - $alarm_name"
        
        # Provide specific recommendations
        case "$alarm_name" in
            *"ReplicaLag"*)
                log_info "    → This alarm requires RDS read replicas to be configured"
                ;;
            *"ErrorRate"*)
                log_info "    → This alarm requires active traffic to generate data"
                ;;
            *"WAF"*)
                log_info "    → This alarm requires WAF to be configured and receiving traffic"
                ;;
            *"Aurora"*)
                log_info "    → This alarm requires Aurora clusters to be running"
                ;;
            *"EKS"*|*"ECS"*|*"Fargate"*)
                log_info "    → This alarm requires Container Insights to be enabled"
                ;;
            *)
                log_info "    → This alarm requires the corresponding AWS service to be active"
                ;;
        esac
    fi
done

log_info ""
log_info "Recommendations:"
log_info "1. Alarms with INSUFFICIENT_DATA are normal when services are not active"
log_info "2. These alarms will start working once the services generate metrics"
log_info "3. Consider disabling alarms for services you don't use"
log_info "4. For testing, you can create sample resources to generate metrics"

# Count total alarms
TOTAL_ALARMS=$(aws cloudwatch describe-alarms \
    --alarm-name-prefix "$ALARM_PREFIX" \
    --profile "$AWS_PROFILE" \
    --region "$AWS_REGION" \
    --query 'length(MetricAlarms)')

INSUFFICIENT_COUNT=$(echo "$INSUFFICIENT_DATA_ALARMS" | tr '\t' '\n' | grep -c . || echo "0")
WORKING_COUNT=$((TOTAL_ALARMS - INSUFFICIENT_COUNT))

log_info ""
log_info "Summary:"
log_info "  Total alarms: $TOTAL_ALARMS"
log_info "  Working alarms: $WORKING_COUNT"
log_info "  Insufficient data: $INSUFFICIENT_COUNT"
log_info "  Success rate: $(( (WORKING_COUNT * 100) / TOTAL_ALARMS ))%"