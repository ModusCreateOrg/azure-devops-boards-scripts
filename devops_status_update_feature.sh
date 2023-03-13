#!/bin/bash

echo "*** Status Update Feature"

if [[ "$states_enabled" != "1" ]]; then
    echo "state update disabled"
    exit
fi

echo "feature_id: ${feature_id}"
echo "project_name: ${project_name}"

states_1=$(echo $states | jq --arg project_name "$project_name" -r '.[] | select(.project==$project_name) | .states_1')
states_1_set_status=$(echo $states | jq --arg project_name "$project_name" -r '.[] | select(.project==$project_name) | .states_1_set_status')
states_2=$(echo $states | jq --arg project_name "$project_name" -r '.[] | select(.project==$project_name) | .states_2')
states_2_set_status=$(echo $states | jq --arg project_name "$project_name" -r '.[] | select(.project==$project_name) | .states_2_set_status')
states_3=$(echo $states | jq --arg project_name "$project_name" -r '.[] | select(.project==$project_name) | .states_3')
states_3_set_status=$(echo $states | jq --arg project_name "$project_name" -r '.[] | select(.project==$project_name) | .states_3_set_status')
states_4=$(echo $states | jq --arg project_name "$project_name" -r '.[] | select(.project==$project_name) | .states_4')
states_4_set_status=$(echo $states | jq --arg project_name "$project_name" -r '.[] | select(.project==$project_name) | .states_4_set_status')
states_5=$(echo $states | jq --arg project_name "$project_name" -r '.[] | select(.project==$project_name) | .states_5')
states_5_set_status=$(echo $states | jq --arg project_name "$project_name" -r '.[] | select(.project==$project_name) | .states_5_set_status')
states_6=$(echo $states | jq --arg project_name "$project_name" -r '.[] | select(.project==$project_name) | .states_6')
states_6_set_status=$(echo $states | jq --arg project_name "$project_name" -r '.[] | select(.project==$project_name) | .states_6_set_status')
states_7=$(echo $states | jq --arg project_name "$project_name" -r '.[] | select(.project==$project_name) | .states_7')
states_7_set_status=$(echo $states | jq --arg project_name "$project_name" -r '.[] | select(.project==$project_name) | .states_7_set_status')
states_8=$(echo $states | jq --arg project_name "$project_name" -r '.[] | select(.project==$project_name) | .states_8')
states_8_set_status=$(echo $states | jq --arg project_name "$project_name" -r '.[] | select(.project==$project_name) | .states_8_set_status')
states_9=$(echo $states | jq --arg project_name "$project_name" -r '.[] | select(.project==$project_name) | .states_9')
states_9_set_status=$(echo $states | jq --arg project_name "$project_name" -r '.[] | select(.project==$project_name) | .states_9_set_status')

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
at_least_one_blocked=0
state_final_id=0

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

    # Set state_final_id to have a priority
    if [[ " ${states_1_one[*]} " =~ " $backlog_system_state " && ${state_final} < 5 ]]; then
        state_final_id=5
    elif [[ " ${states_2_one[*]} " =~ " $backlog_system_state " && ${state_final} < 4 ]]; then
        state_final_id=4
    elif [[ " ${states_3_one[*]} " =~ " $backlog_system_state " && ${state_final} < 3 ]]; then
        state_final_id=3
    elif [[ " ${states_4_one[*]} " =~ " $backlog_system_state " && ${state_final} < 2 ]]; then
        state_final_id=2
    elif [[ " ${states_5_one[*]} " =~ " $backlog_system_state " && ${state_final} < 1 ]]; then
        state_final_id=1
    fi

    echo "story_id:  ${backlog_id} - state: ${backlog_system_state}"
    echo "state_final:  ${state_final_id}"
done

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

if [[ ${state_all_same} == 1 && ${state_final} == "" ]]; then
    if [[ " ${states_1[*]} " =~ " $state " ]]; then
        state_final="${states_1_set_status}"
    elif [[ " ${states_2[*]} " =~ " $state " ]]; then
        state_final="${states_2_set_status}"
    elif [[ " ${states_3[*]} " =~ " $state " ]]; then
        state_final="${states_3_set_status}"
    elif [[ " ${states_4[*]} " =~ " $state " ]]; then
        state_final="${states_4_set_status}"
    elif [[ " ${states_5[*]} " =~ " $state " ]]; then
        state_final="${states_5_set_status}"
    elif [[ " ${states_6[*]} " =~ " $state " ]]; then
        state_final="${states_6_set_status}"
    elif [[ " ${states_7[*]} " =~ " $state " ]]; then
        state_final="${states_7_set_status}"
    elif [[ " ${states_8[*]} " =~ " $state " ]]; then
        state_final="${states_8_set_status}"
    elif [[ " ${states_9[*]} " =~ " $state " ]]; then
        state_final="${states_9_set_status}"      
    fi
fi

if ! [[ -z $state ]]; then
    feature_update=$(az boards work-item update --id ${feature_id} --fields "System.State=${state_final}")
fi

echo "Status_Final:  ${state_final}"
