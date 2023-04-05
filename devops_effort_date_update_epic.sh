#!/bin/bash

echo "*** Effort Update Epic"

source devops_variables.sh

# Get parameters
epic_id=$1
project_name=$2

# Get all backlog itens
backlog_total=0
backlog_total_completed=0
epic_effort_total=0
epic_completed_effort_total=0

echo "epic_id: ${epic_id}"
echo "project_name: ${project_name}"

re='^[0-9]+$'

features=$(az boards query --wiql "SELECT System.State, Microsoft.VSTS.Scheduling.${effort_name}, Custom.${completed_effort_name}, Microsoft.VSTS.Scheduling.StartDate, Microsoft.VSTS.Scheduling.TargetDate FROM workitems where [System.TeamProject] = '${project_name}' and [System.Parent] = '${epic_id}' and [System.WorkItemType] = '${feature_name}'")
for row_feature in $(echo "${features}" | jq -r '.[] | @base64'); do
    _jq() {
    echo ${row_feature} | base64 --decode | jq -r ${1}
    }

    #Effort
    feature_effort=$(_jq '.fields."Microsoft.VSTS.Scheduling.'${effort_name}'"')
    if [[ ${feature_effort} =~ $re ]] ; then
        epic_effort_total=$((epic_effort_total+feature_effort))
        backlog_total=$((backlog_total+1))
    fi

    feature_completed_effort=$(_jq '.fields."Custom.'${completed_effort_name}'"')
    if [[ ${feature_completed_effort} =~ $re ]] ; then
        epic_completed_effort_total=$((epic_completed_effort_total+feature_completed_effort))
    fi

    backlog_sytem_state=$(_jq '.fields."System.State"')
    if [ "$backlog_sytem_state" == "${state_done_name}" ]; then
        backlog_total_completed=$((backlog_total_completed+1))
    fi

    # Date
    feature_start_date=$(_jq '.fields."Microsoft.VSTS.Scheduling.StartDate"')
    feature_target_date=$(_jq '.fields."Microsoft.VSTS.Scheduling.TargetDate"')
    if [[ ${epic_min_start_date} == '' && ${feature_start_date} == *"T"* ]]; then
        epic_min_start_date=${feature_start_date}
    fi
    if [[ ${epic_max_finish_date} == '' && ${feature_target_date} == *"T"* ]]; then
        epic_max_finish_date=${feature_target_date}
    fi

    if [[ ${feature_start_date} == *"T"* ]]; then
        # Get the minimum date from backlog
        if [[ ${feature_start_date} < ${epic_min_start_date} ]]; then
            epic_min_start_date=${feature_start_date}
        fi
    fi

    if [[ ${feature_target_date} == *"T"* ]]; then
        # Get the maximum date from backlog
        if [[ ${feature_target_date} > ${epic_max_finish_date} ]]; then
            epic_max_finish_date=${feature_target_date}
        fi
    fi
done
echo "EFFORT total: ${epic_effort_total} - completed effort total: ${epic_completed_effort_total}"

if [[ ${epic_effort_total} == "0" ]]; then
    percentage_epic_effort_total=0
else 
    percentage_epic_effort_total=$(jq -n ${epic_completed_effort_total}/${epic_effort_total}*100  | jq floor)
fi

# Update features values
epic_update_1=$(az boards work-item update --id ${epic_id} --fields "Microsoft.VSTS.Scheduling.${effort_name}=${epic_effort_total}" "Custom.${completed_effort_name}=${epic_completed_effort_total}" "Custom.${percentage_completed_effort_name}=${percentage_epic_effort_total}")
epic_update_2=$(az boards work-item update --id ${epic_id} --fields "Start Date=${epic_min_start_date}" "Target Date=${epic_max_finish_date}")

if [[ ${effort_name} != "Effort" ]]; then
    epic_update_3=$(az boards work-item update --id ${epic_id} --fields "Effort=${epic_effort_total}")
fi

if [[ ${total_effort_name} != "" ]]; then
    epic_update_4=$(az boards work-item update --id ${epic_id} --fields "Custom.${total_effort_name}=${backlog_total_completed}|${backlog_total}")
fi

echo "epic_effort_total: ${epic_effort_total}"
echo "epic_completed_effort_total: ${epic_completed_effort_total}"
echo "percentage_epic_effort_total: ${percentage_epic_effort_total}"
echo "epic_min_start_date: ${epic_min_start_date}"
echo "epic_max_finish_date: ${epic_max_finish_date}"
