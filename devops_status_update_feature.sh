#!/bin/bash

echo "*** Status Update Feature"

if [[ "$states_enabled" != "1" ]]; then
    echo "state update disabled"
    exit
fi

echo "feature_id: ${feature_id}"
echo "project_name: ${project_name}"

states_1_all=$(echo $states | jq --arg project_name "$project_name" -r '.[] | select(.project==$project_name) | .states_1_all')
states_1_all_set_status=$(echo $states | jq --arg project_name "$project_name" -r '.[] | select(.project==$project_name) | .states_1_all_set_status')
states_2_all=$(echo $states | jq --arg project_name "$project_name" -r '.[] | select(.project==$project_name) | .states_2_all')
states_2_all_set_status=$(echo $states | jq --arg project_name "$project_name" -r '.[] | select(.project==$project_name) | .states_2_all_set_status')
states_3_all=$(echo $states | jq --arg project_name "$project_name" -r '.[] | select(.project==$project_name) | .states_3_all')
states_3_all_set_status=$(echo $states | jq --arg project_name "$project_name" -r '.[] | select(.project==$project_name) | .states_3_all_set_status')
states_4_all=$(echo $states | jq --arg project_name "$project_name" -r '.[] | select(.project==$project_name) | .states_4_all')
states_4_all_set_status=$(echo $states | jq --arg project_name "$project_name" -r '.[] | select(.project==$project_name) | .states_4_all_set_status')
states_5_all=$(echo $states | jq --arg project_name "$project_name" -r '.[] | select(.project==$project_name) | .states_5_all')
states_5_all_set_status=$(echo $states | jq --arg project_name "$project_name" -r '.[] | select(.project==$project_name) | .states_5_all_set_status')

states_1_or=$(echo $states | jq --arg project_name "$project_name" -r '.[] | select(.project==$project_name) | .states_1_or')
states_1_or_set_status=$(echo $states | jq --arg project_name "$project_name" -r '.[] | select(.project==$project_name) | .states_1_or_set_status')
states_2_or=$(echo $states | jq --arg project_name "$project_name" -r '.[] | select(.project==$project_name) | .states_2_or')
states_2_or_set_status=$(echo $states | jq --arg project_name "$project_name" -r '.[] | select(.project==$project_name) | .states_2_or_set_status')
states_3_or=$(echo $states | jq --arg project_name "$project_name" -r '.[] | select(.project==$project_name) | .states_3_or')
states_3_or_set_status=$(echo $states | jq --arg project_name "$project_name" -r '.[] | select(.project==$project_name) | .states_3_or_set_status')
states_4_or=$(echo $states | jq --arg project_name "$project_name" -r '.[] | select(.project==$project_name) | .states_4_or')
states_4_or_set_status=$(echo $states | jq --arg project_name "$project_name" -r '.[] | select(.project==$project_name) | .states_4_or_set_status')
states_5_or=$(echo $states | jq --arg project_name "$project_name" -r '.[] | select(.project==$project_name) | .states_5_or')
states_5_or_set_status=$(echo $states | jq --arg project_name "$project_name" -r '.[] | select(.project==$project_name) | .states_5_or_set_status')

states_1_one=$(echo $states | jq --arg project_name "$project_name" -r '.[] | select(.project==$project_name) | .states_1_one')
states_1_one_set_status=$(echo $states | jq --arg project_name "$project_name" -r '.[] | select(.project==$project_name) | .states_1_one_set_status')
states_2_one=$(echo $states | jq --arg project_name "$project_name" -r '.[] | select(.project==$project_name) | .states_2_one')
states_2_one_set_status=$(echo $states | jq --arg project_name "$project_name" -r '.[] | select(.project==$project_name) | .states_2_one_set_status')
states_3_one=$(echo $states | jq --arg project_name "$project_name" -r '.[] | select(.project==$project_name) | .states_3_one')
states_3_one_set_status=$(echo $states | jq --arg project_name "$project_name" -r '.[] | select(.project==$project_name) | .states_3_one_set_status')
states_4_one=$(echo $states | jq --arg project_name "$project_name" -r '.[] | select(.project==$project_name) | .states_4_one')
states_4_one_set_status=$(echo $states | jq --arg project_name "$project_name" -r '.[] | select(.project==$project_name) | .states_4_one_set_status')
states_5_one=$(echo $states | jq --arg project_name "$project_name" -r '.[] | select(.project==$project_name) | .states_5_one')
states_5_one_set_status=$(echo $states | jq --arg project_name "$project_name" -r '.[] | select(.project==$project_name) | .states_5_one_set_status')

# Get all backlog itens
state=""
state_all_same=1
state_final=""
state_final_id=0
total_work_item=0
group_final_1=0
group_final_2=0
group_final_3=0
group_final_4=0
group_final_5=0

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

    # check if all work items have the same status
    if [[ "$backlog_system_state" == "$state" ]]; then
        state=$backlog_system_state
    else
        state_all_same=0
    fi

    # Group status (AND)
    if [[ " ${states_1_or[*]} " =~ " $backlog_system_state " ]]; then
        group_final_1=$((${group_final_1} + 1))
    fi
    if [[ " ${states_2_or[*]} " =~ " $backlog_system_state " ]]; then
        group_final_2=$((${group_final_2} + 1))
    fi
    if [[ " ${states_3_or[*]} " =~ " $backlog_system_state " ]]; then
        group_final_3=$((${group_final_3} + 1))
    fi
    if [[ " ${states_4_or[*]} " =~ " $backlog_system_state " ]]; then
        group_final_4=$((${group_final_4} + 1))
    fi
    if [[ " ${states_5_or[*]} " =~ " $backlog_system_state " ]]; then
        group_final_5=$((${group_final_5} + 1))
    fi

    # Set status (ANY)
    if [[ " ${states_1_one[*]} " =~ " $backlog_system_state " && ${state_final_id} < 5 ]]; then
        state_final_id=5
    elif [[ " ${states_2_one[*]} " =~ " $backlog_system_state " && ${state_final_id} < 4 ]]; then
        state_final_id=4
    elif [[ " ${states_3_one[*]} " =~ " $backlog_system_state " && ${state_final_id} < 3 ]]; then
        state_final_id=3
    elif [[ " ${states_4_one[*]} " =~ " $backlog_system_state " && ${state_final_id} < 2 ]]; then
        state_final_id=2
    elif [[ " ${states_5_one[*]} " =~ " $backlog_system_state " && ${state_final_id} < 1 ]]; then
        state_final_id=1
    fi

    total_work_item=$((${total_work_item} + 1))

    echo "story_id:  ${backlog_id} - state: ${backlog_system_state}"
    echo "total_work_item:  ${total_work_item}"
done

echo "state_final_id: ${state_final_id}"
echo "group_final_1: ${group_final_1}"
echo "group_final_2: ${group_final_2}"
echo "group_final_3: ${group_final_3}"
echo "group_final_4: ${group_final_4}"
echo "group_final_5: ${group_final_5}"

if [[ ${state_all_same} == 1 ]]; then
    if [[ " ${states_1_all[*]} " =~ " $state " ]]; then
        state_final="${states_1_all_set_status}"
    elif [[ " ${states_2_all[*]} " =~ " $state " ]]; then
        state_final="${states_2_all_set_status}"
    elif [[ " ${states_3_all[*]} " =~ " $state " ]]; then
        state_final="${states_3_all_set_status}"
    elif [[ " ${states_4_all[*]} " =~ " $state " ]]; then
        state_final="${states_4_all_set_status}"
    elif [[ " ${states_5_all[*]} " =~ " $state " ]]; then
        state_final="${states_5_all_set_status}"  
    fi
    echo "all the same"
fi

if [[ ${state_final} == "" ]]; then
    if [[ ${group_final_1} == ${total_work_item} ]]; then
        state_final="${states_1_or_set_status}"
    elif [[ ${group_final_2} == ${total_work_item} ]]; then
        state_final="${states_2_or_set_status}"
    elif [[ ${group_final_3} == ${total_work_item} ]]; then
        state_final="${states_3_or_set_status}"
    elif [[ ${group_final_4} == ${total_work_item} ]]; then
        state_final="${states_4_or_set_status}"
    elif [[ ${group_final_5} == ${total_work_item} ]]; then
        state_final="${states_5_or_set_status}"
    fi
    echo "or"
fi

if [[ ${state_final} == "" ]]; then
    if [[ ${state_final_id} == 1 ]]; then
        state_final="${states_5_one_set_status}"
    elif [[ ${state_final_id} == 2 ]]; then
        state_final="${states_4_one_set_status}"
    elif [[ ${state_final_id} == 3 ]]; then
        state_final="${states_3_one_set_status}"
    elif [[ ${state_final_id} == 4 ]]; then
        state_final="${states_2_one_set_status}"
    elif [[ ${state_final_id} == 5 ]]; then
        state_final="${states_1_one_set_status}"
    fi
    echo "one"
fi

if ! [[ -z $state ]]; then
    feature_update=$(az boards work-item update --id ${feature_id} --fields "System.State=${state_final}")
fi

echo "Status_Final:  ${state_final}"
