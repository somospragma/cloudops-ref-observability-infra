#!/bin/bash

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
source "$PROJECT_ROOT/utils/common-functions.sh"
load_config

if ! is_service_enabled "EKS"; then
    log_warning "EKS alarms are disabled in configuration"
    exit 0
fi

log_info "Deploying EKS CloudWatch Alarms..."

# Note: EKS requires Container Insights to be enabled for these metrics
create_alarm "${ALARM_PREFIX}-EKS-NodeCPU-Critical" "EKS node CPU utilization is high" "node_cpu_utilization" "ContainerInsights" "90" "GreaterThanThreshold" "$SNS_TOPIC_CRITICAL"
create_alarm "${ALARM_PREFIX}-EKS-NodeMemory-Critical" "EKS node memory utilization is high" "node_memory_utilization" "ContainerInsights" "90" "GreaterThanThreshold" "$SNS_TOPIC_CRITICAL"
create_alarm "${ALARM_PREFIX}-EKS-PodCPU-Warning" "EKS pod CPU utilization is high" "pod_cpu_utilization" "ContainerInsights" "90" "GreaterThanThreshold" "$SNS_TOPIC_WARNING"
create_alarm "${ALARM_PREFIX}-EKS-PodMemory-Warning" "EKS pod memory utilization is high" "pod_memory_utilization" "ContainerInsights" "90" "GreaterThanThreshold" "$SNS_TOPIC_WARNING"

log_success "EKS CloudWatch Alarms deployment completed!"
log_warning "Note: EKS alarms require Container Insights to be enabled"