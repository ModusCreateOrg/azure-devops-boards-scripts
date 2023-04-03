#!/bin/bash

echo "*** Effort Update Feature"

source devops_variables.sh

# Get parameters
feature_id=$1
project_name=$2

# Get all backlog itens
backlog_total=0
backlog_total_completed=0
backlog_effort_total=0
backlog_completed_effort_total=0

backlogs=$(az boards query --wiql "SELECT id, Microsoft.VSTS.Scheduling.${effort_name}, System.State, System.IterationId, System.IterationPath FROM workitems where [System.TeamProject] = '${project_name}' and [System.Parent] = '${feature_id}' and [System.WorkItemType] = '${backlog_item_name}'")
for row_backlog in $(echo "${backlogs}" | jq -r '.[] | @base64'); do
    _jq() {
    echo ${row_backlog} | base64 --decode | jq -r ${1}
    }
    backlog_id=$(_jq '.id')
    backlog_effort=$(_jq '.fields."Microsoft.VSTS.Scheduling.'${effort_name}'"')
    if [[ ${backlog_effort} =~ $re ]] ; then
        backlog_effort_total=$((backlog_effort_total+backlog_effort))
        backlog_total=$((backlog_total+1))
    fi
    backlog_sytem_state=$(_jq '.fields."System.State"')
    if [ "$backlog_sytem_state" == "${state_done_name}" ]; then
        backlog_completed_effort_total=$((backlog_completed_effort_total+backlog_effort))
        backlog_total_completed=$((backlog_total_completed+1))
    fi
    echo "BACKLOG:  ${backlog_id} - EFFORT: ${backlog_effort} - STATE: ${backlog_sytem_state}"
done
echo "total": ${backlog_effort_total}

if [[ ${backlog_effort_total} == "0" ]]; then
    percentage_effort_total=0
else 
    percentage_effort_total=$(jq -n ${backlog_completed_effort_total}/${backlog_effort_total}*100  | jq floor)
fi

if [[ ${effort_name} != "Effort" ]]; then
    feature_update=$(az boards work-item update --id ${feature_id} --fields "Effort=${backlog_effort_total}" "Microsoft.VSTS.Scheduling.${effort_name}=${backlog_effort_total}" "Custom.${completed_effort_name}=${backlog_completed_effort_total}" "Custom.${percentage_completed_effort_name}=${percentage_effort_total}")
else
    feature_update=$(az boards work-item update --id ${feature_id} --fields "Effort=${backlog_effort_total}" "Custom.${completed_effort_name}=${backlog_completed_effort_total}" "Custom.${percentage_completed_effort_name}=${percentage_effort_total}")
fi

if [[ ${total_effort_name} != "" ]]; then
    feature_update_2=$(az boards work-item update --id ${feature_id} --fields "Custom.${total_effort_name}=${backlog_total}|${backlog_total_completed}")
fi

echo "backlog_effort_total: ${backlog_effort_total}"
echo "backlog_completed_effort_total: ${backlog_completed_effort_total}"

source devops_status_update_feature.sh
