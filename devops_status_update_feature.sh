#!/bin/bash
# set -o xtrace

echo "*** Status Update Feature"


echo "feature_id: ${feature_id}"
echo "project_name: ${project_name}"

# Get all backlog itens
state=""
state_all_same=1
state_final=""
at_least_one_blocked=0

backlogs=$(az boards query --wiql "SELECT id, System.State FROM workitems where [System.TeamProject] = '${project_name}' and [System.Parent] = '${feature_id}' and [System.WorkItemType] = '${backlog_item_name}'")

for row_backlog in $(echo "${backlogs}" | jq -r '.[] | @base64'); do
    _jq() {
    echo ${row_backlog} | base64 --decode | jq -r ${1}
    }
    backlog_id=$(_jq '.id')
    backlog_system_state=$(_jq '.fields."System.State"')

    if [[ -z $state ]]; then
        state=$backlog_system_state
    fi

    if [[ "$backlog_system_state" == "$state" ]]; then
        state=$backlog_system_state
    else
        state_all_same=0
    fi

    if [[ ${state} == "Blocked" ]]; then
        at_least_one_blocked=1
    fi

    echo "Story_ID:  ${backlog_id} - STATE: ${backlog_system_state}"
done


if [[ $state_all_same == 1 ]]; then 
    if [[ " ${states_closed[*]} " =~ " $state " ]]; then
        state_final="${states_closed_set_status}"
    elif [[ " ${states_in_development[*]} " =~ " $state " ]]; then
        state_final="${states_in_development_set_status}"
    elif [[ " ${states_resolved[*]} " =~ " $state " ]]; then
        state_final="${states_resolved_set_status}"
    elif [[ " ${states_not_started[*]} " =~ " $state " ]]; then
        state_final="${states_not_started_set_status}"
    elif [[ " ${states_blocked[*]} " =~ " $state " ]]; then
        state_final="${states_blocked_set_status}"
    else
        state_final=""
    fi

else
    if [[ $at_least_one_blocked == 1 ]]; then
        state_final="${states_blocked_set_status}"
    else
        state_final="${states_in_development_set_status}"
    fi

fi



if ! [[ -z $state ]]; then
    feature_update=$(az boards work-item update --id ${feature_id} --fields "System.State=${state_final}")
fi

echo "Status_Final:  ${state_final}"
