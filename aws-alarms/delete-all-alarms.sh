#!/bin/bash

# Delete All AWS CloudWatch Alarms
# Cleanup script for removing all project alarms

set -e

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load common functions and configuration
source "$SCRIPT_DIR/utils/common-functions.sh"

# Check AWS CLI and load configuration
check_aws_cli
load_config

log_warning "This will delete ALL CloudWatch alarms with prefix: $ALARM_PREFIX"
log_warning "This action cannot be undone!"

# Confirmation prompt
read -p "Are you sure you want to continue? (yes/no): " confirm
if [[ "$confirm" != "yes" ]]; then
    log_info "Operation cancelled"
    exit 0
fi

log_info "Deleting all CloudWatch alarms with prefix: $ALARM_PREFIX"

# Get all alarm names with the prefix
alarm_names=$(aws cloudwatch describe-alarms \
    --alarm-name-prefix "$ALARM_PREFIX" \
    --query 'MetricAlarms[*].AlarmName' \
    --output text)

if [[ -z "$alarm_names" ]]; then
    log_info "No alarms found with prefix: $ALARM_PREFIX"
    exit 0
fi

# Convert to array
IFS=$'\t' read -ra alarms_array <<< "$alarm_names"
total_alarms=${#alarms_array[@]}

log_info "Found $total_alarms alarms to delete"

# Delete alarms in batches (AWS CLI limit is 100 alarms per call)
batch_size=100
current_batch=0

for ((i=0; i<total_alarms; i+=batch_size)); do
    current_batch=$((current_batch + 1))
    batch_end=$((i + batch_size - 1))
    
    if [[ $batch_end -ge $total_alarms ]]; then
        batch_end=$((total_alarms - 1))
    fi
    
    log_info "Deleting batch $current_batch (alarms $((i+1)) to $((batch_end+1)))"
    
    # Create batch array
    batch_alarms=("${alarms_array[@]:$i:$batch_size}")
    
    # Delete batch
    if aws cloudwatch delete-alarms --alarm-names "${batch_alarms[@]}"; then
        log_success "Deleted batch $current_batch successfully"
    else
        log_error "Failed to delete batch $current_batch"
        exit 1
    fi
done

log_info "Note: Anomaly detectors are not used in this implementation"

log_success "All CloudWatch alarms and anomaly detectors deleted successfully!"

# Verify deletion
remaining_alarms=$(aws cloudwatch describe-alarms \
    --alarm-name-prefix "$ALARM_PREFIX" \
    --query 'MetricAlarms[*].AlarmName' \
    --output text)

if [[ -z "$remaining_alarms" ]]; then
    log_success "Verification: No alarms remaining with prefix $ALARM_PREFIX"
else
    log_warning "Verification: Some alarms may still exist:"
    echo "$remaining_alarms"
fi

log_info "Cleanup completed! 🧹"