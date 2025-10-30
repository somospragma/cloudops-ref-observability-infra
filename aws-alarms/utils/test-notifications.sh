#!/bin/bash

# Test SNS Notifications
# Script to test SNS topic notifications

set -e

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Load common functions and configuration
source "$PROJECT_ROOT/utils/common-functions.sh"
load_config

log_info "Testing SNS Notifications..."

# Test critical notifications
log_info "Testing critical notifications..."
if test_sns_notification "$SNS_TOPIC_CRITICAL" "🚨 TEST: Critical Alert from AWS CloudWatch Alarms - $PROJECT_NAME ($ENVIRONMENT)"; then
    log_success "Critical notification test completed"
else
    log_error "Critical notification test failed"
fi

echo

# Test warning notifications
log_info "Testing warning notifications..."
if test_sns_notification "$SNS_TOPIC_WARNING" "⚠️ TEST: Warning Alert from AWS CloudWatch Alarms - $PROJECT_NAME ($ENVIRONMENT)"; then
    log_success "Warning notification test completed"
else
    log_error "Warning notification test failed"
fi

echo

# Test info notifications (if configured)
if [[ -n "$SNS_TOPIC_INFO" ]]; then
    log_info "Testing info notifications..."
    if test_sns_notification "$SNS_TOPIC_INFO" "ℹ️ TEST: Info Alert from AWS CloudWatch Alarms - $PROJECT_NAME ($ENVIRONMENT)"; then
        log_success "Info notification test completed"
    else
        log_error "Info notification test failed"
    fi
fi

log_success "SNS notification testing completed!"
log_info "Check your configured notification channels (email, Slack, etc.) for test messages"