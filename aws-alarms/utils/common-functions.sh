#!/bin/bash

# Common functions for AWS CloudWatch Alarms

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if AWS CLI is installed and configured
check_aws_cli() {
    if ! command -v aws &> /dev/null; then
        log_error "AWS CLI is not installed. Please install it first."
        exit 1
    fi
    
    if ! aws sts get-caller-identity --profile "$AWS_PROFILE" --region "$AWS_REGION" &> /dev/null; then
        log_error "AWS CLI is not configured or credentials are invalid for profile: $AWS_PROFILE"
        exit 1
    fi
    
    log_success "AWS CLI is configured and working with profile: $AWS_PROFILE"
}

# Load configuration
load_config() {
    local config_file="config/config.env"
    
    if [[ ! -f "$config_file" ]]; then
        log_error "Configuration file not found: $config_file"
        log_info "Please copy config.env.example to config.env and configure it"
        exit 1
    fi
    
    source "$config_file"
    log_success "Configuration loaded from $config_file"
}

# Create CloudWatch alarm
create_alarm() {
    local alarm_name="$1"
    local alarm_description="$2"
    local metric_name="$3"
    local namespace="$4"
    local threshold="$5"
    local comparison_operator="$6"
    local sns_topic="$7"
    local dimensions="$8"
    local statistic="${9:-Average}"
    local period="${10:-300}"
    local evaluation_periods="${11:-$EVALUATION_PERIODS}"
    local datapoints_to_alarm="${12:-$DATAPOINTS_TO_ALARM}"
    
    log_info "Creating alarm: $alarm_name"
    
    aws cloudwatch put-metric-alarm \
        --alarm-name "$alarm_name" \
        --alarm-description "$alarm_description" \
        --metric-name "$metric_name" \
        --namespace "$namespace" \
        --statistic "$statistic" \
        --period $period \
        --threshold $threshold \
        --comparison-operator "$comparison_operator" \
        --evaluation-periods $evaluation_periods \
        --datapoints-to-alarm $datapoints_to_alarm \
        --alarm-actions "$sns_topic" \
        --treat-missing-data "$TREAT_MISSING_DATA" \
        --profile "$AWS_PROFILE" \
        --region "$AWS_REGION"
    
    if [[ $? -eq 0 ]]; then
        log_success "Created alarm: $alarm_name"
        return 0
    else
        log_error "Failed to create alarm: $alarm_name"
        return 1
    fi
}

# Delete CloudWatch alarm
delete_alarm() {
    local alarm_name="$1"
    
    log_info "Deleting alarm: $alarm_name"
    
    if aws cloudwatch delete-alarms --alarm-names "$alarm_name"; then
        log_success "Deleted alarm: $alarm_name"
        return 0
    else
        log_error "Failed to delete alarm: $alarm_name"
        return 1
    fi
}

# Check if alarm exists
alarm_exists() {
    local alarm_name="$1"
    
    aws cloudwatch describe-alarms --alarm-names "$alarm_name" --query 'MetricAlarms[0].AlarmName' --output text 2>/dev/null | grep -q "$alarm_name"
}

# List alarms with prefix
list_alarms() {
    local prefix="${1:-$ALARM_PREFIX}"
    
    log_info "Listing alarms with prefix: $prefix"
    aws cloudwatch describe-alarms --alarm-name-prefix "$prefix" --query 'MetricAlarms[*].[AlarmName,StateValue,StateReason]' --output table
}

# Get alarm state
get_alarm_state() {
    local alarm_name="$1"
    
    aws cloudwatch describe-alarms --alarm-names "$alarm_name" --query 'MetricAlarms[0].StateValue' --output text 2>/dev/null
}

# Validate SNS topic exists
validate_sns_topic() {
    local topic_arn="$1"
    
    if aws sns get-topic-attributes --topic-arn "$topic_arn" &>/dev/null; then
        return 0
    else
        log_warning "SNS topic does not exist or is not accessible: $topic_arn"
        return 1
    fi
}

# Create SNS topic if it doesn't exist
create_sns_topic() {
    local topic_name="$1"
    
    log_info "Creating SNS topic: $topic_name"
    
    local topic_arn=$(aws sns create-topic --name "$topic_name" --query 'TopicArn' --output text)
    
    if [[ $? -eq 0 ]]; then
        log_success "Created SNS topic: $topic_arn"
        echo "$topic_arn"
        return 0
    else
        log_error "Failed to create SNS topic: $topic_name"
        return 1
    fi
}

# Subscribe email to SNS topic
subscribe_email_to_topic() {
    local topic_arn="$1"
    local email="$2"
    
    log_info "Subscribing email $email to topic $topic_arn"
    
    if aws sns subscribe --topic-arn "$topic_arn" --protocol email --notification-endpoint "$email"; then
        log_success "Subscribed $email to $topic_arn"
        log_warning "Please check your email and confirm the subscription"
        return 0
    else
        log_error "Failed to subscribe $email to $topic_arn"
        return 1
    fi
}

# Test SNS notification
test_sns_notification() {
    local topic_arn="$1"
    local message="${2:-Test notification from AWS CloudWatch Alarms}"
    
    log_info "Sending test notification to $topic_arn"
    
    if aws sns publish --topic-arn "$topic_arn" --message "$message"; then
        log_success "Test notification sent successfully"
        return 0
    else
        log_error "Failed to send test notification"
        return 1
    fi
}

# Get AWS account ID
get_account_id() {
    aws sts get-caller-identity --query 'Account' --output text
}

# Get current AWS region
get_current_region() {
    aws configure get region
}

# Format dimensions for AWS CLI
format_dimensions() {
    local dimensions_string="$1"
    echo "$dimensions_string"
}

# Check if service is enabled
is_service_enabled() {
    local service="$1"
    local service_upper=$(echo "$service" | tr '[:lower:]' '[:upper:]')
    local var_name="ENABLE_${service_upper}_ALARMS"
    local enabled="${!var_name}"
    
    [[ "$enabled" == "true" ]]
}

# Progress indicator
show_progress() {
    local current="$1"
    local total="$2"
    local service="$3"
    
    local percentage=$((current * 100 / total))
    log_info "Progress: [$current/$total] ($percentage%) - $service"
}