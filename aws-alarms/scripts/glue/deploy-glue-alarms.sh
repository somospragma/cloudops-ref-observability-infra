#!/bin/bash

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
source "$PROJECT_ROOT/utils/common-functions.sh"
load_config

if ! is_service_enabled "GLUE"; then
    log_warning "Glue alarms are disabled in configuration"
    exit 0
fi

log_info "Deploying Glue CloudWatch Alarms..."

create_alarm "${ALARM_PREFIX}-Glue-FailedTasks-Critical" "Glue job has failed tasks" "glue.driver.aggregate.numFailedTasks" "Glue" "0" "GreaterThanThreshold" "$SNS_TOPIC_CRITICAL"
create_alarm "${ALARM_PREFIX}-Glue-KilledTasks-Critical" "Glue job has killed tasks" "glue.driver.aggregate.numKilledTasks" "Glue" "0" "GreaterThanThreshold" "$SNS_TOPIC_CRITICAL"
create_alarm "${ALARM_PREFIX}-Glue-ElapsedTime-Warning" "Glue job elapsed time is high" "glue.driver.aggregate.elapsedTime" "Glue" "14400" "GreaterThanThreshold" "$SNS_TOPIC_WARNING"
create_alarm "${ALARM_PREFIX}-Glue-JVMHeapUsage-Warning" "Glue JVM heap usage is high" "glue.driver.jvm.heap.usage" "Glue" "90" "GreaterThanThreshold" "$SNS_TOPIC_WARNING"

log_success "Glue CloudWatch Alarms deployment completed!"