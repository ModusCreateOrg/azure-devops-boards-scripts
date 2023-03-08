#!/bin/bash

echo "*** Date Update Feature"

source devops_variables.sh

# Get parameters
feature_id=$1
project_name=$2

backlogs=$(az boards query --wiql "SELECT id,System.IterationId FROM workitems where [System.TeamProject] = '${project_name}' and [System.Parent] = '${feature_id}' and [System.WorkItemType] = '${backlog_item_name}'")

for row_backlog in $(echo "${backlogs}" | jq -r '.[] | @base64'); do
    _jq() {
    echo ${row_backlog} | base64 --decode | jq -r ${1}
    }
    backlog_id=$(_jq '.id')
    backlog_iteration_id=$(_jq '.fields."System.IterationId"')
    echo "backlog_id: ${backlog_id}"    
    echo "iteration_id: ${backlog_iteration_id}"

    backlog_iteration=$(az boards iteration project show --project "${project_name}" --id ${backlog_iteration_id})
    backlog_start_date=$(echo "${backlog_iteration}" | jq -r '.[0] | .attributes.startDate')
    backlog_finish_date=$(echo "${backlog_iteration}" | jq -r '.[0] | .attributes.finishDate')
    echo "startdate: ${backlog_start_date} / finishdate: ${backlog_finish_date}"

    if [[ ${backlog_min_start_date} == '' && ${backlog_start_date} == *"T"* ]]; then
        backlog_min_start_date=${backlog_start_date}
    fi
    if [[ ${backlog_max_finish_date} == '' && ${backlog_finish_date} == *"T"* ]]; then
        backlog_max_finish_date=${backlog_finish_date}
    fi

    if [[ ${backlog_start_date} == *"T"* ]]; then
        # Get the minimum date from backlog
        if [[ ${backlog_start_date} < ${backlog_min_start_date} ]]; then
            backlog_min_start_date=${backlog_start_date}
        fi
    fi

    if [[ ${backlog_finish_date} == *"T"* ]]; then
        # Get the maximum date from backlog
        if [[ ${backlog_finish_date} > ${backlog_max_finish_date} ]]; then
            backlog_max_finish_date=${backlog_finish_date}
        fi
    fi

    # Set timezone
    backlog_min_start_date="${backlog_min_start_date/Z/${time_zone}}"
    backlog_max_finish_date="${backlog_max_finish_date/Z/${time_zone}}"
    echo "new_start_date: ${backlog_min_start_date} / new_finish_date: ${backlog_max_finish_date}"

done

# Update features values
feature_update=$(az boards work-item update --id ${feature_id} --fields "Start Date=${backlog_min_start_date}" "Target Date=${backlog_max_finish_date}")