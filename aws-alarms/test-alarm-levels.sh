#!/bin/bash

# Test script to verify alarm level filtering
# This script simulates alarm creation to show which alarms would be created

set -e

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load common functions and configuration
source "$SCRIPT_DIR/utils/common-functions.sh"
load_config

echo ""
log_info "=========================================="
log_info "ALARM LEVEL CONFIGURATION TEST"
log_info "=========================================="
echo ""

log_info "Current Configuration:"
echo "  DEPLOY_CRITICAL_ALARMS: $DEPLOY_CRITICAL_ALARMS"
echo "  DEPLOY_WARNING_ALARMS: $DEPLOY_WARNING_ALARMS"
echo "  DEPLOY_INFO_ALARMS: $DEPLOY_INFO_ALARMS"
echo ""

# Test alarm names
test_alarms=(
    "demo-EC2-CPU-Critical"
    "demo-EC2-CPU-Warning"
    "demo-EC2-Network-Info"
    "demo-RDS-CPU-Critical"
    "demo-RDS-CPU-Warning"
    "demo-Lambda-Errors-Critical"
    "demo-Lambda-Duration-Warning"
)

log_info "Testing alarm filtering logic:"
echo ""

created_count=0
skipped_count=0

for alarm_name in "${test_alarms[@]}"; do
    if should_create_alarm "$alarm_name"; then
        log_success "✅ WOULD CREATE: $alarm_name"
        created_count=$((created_count + 1))
    else
        log_warning "⏭️  WOULD SKIP: $alarm_name"
        skipped_count=$((skipped_count + 1))
    fi
done

echo ""
log_info "=========================================="
log_info "SUMMARY"
log_info "=========================================="
echo "  Total alarms tested: ${#test_alarms[@]}"
echo "  Would be created: $created_count"
echo "  Would be skipped: $skipped_count"
echo ""

if [[ "$DEPLOY_CRITICAL_ALARMS" == "true" ]] && [[ "$DEPLOY_WARNING_ALARMS" == "false" ]]; then
    log_success "✅ Configuration is set to deploy ONLY CRITICAL alarms"
elif [[ "$DEPLOY_CRITICAL_ALARMS" == "true" ]] && [[ "$DEPLOY_WARNING_ALARMS" == "true" ]]; then
    log_success "✅ Configuration is set to deploy CRITICAL and WARNING alarms"
else
    log_warning "⚠️  Custom configuration detected"
fi

echo ""
log_info "To change configuration, edit: config/config.env"
log_info "Then run: make deploy"
echo ""
