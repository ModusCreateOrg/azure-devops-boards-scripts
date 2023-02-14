#!/bin/bash
# set -o xtrace

# --------------------------------------------------------
# CAUTION!
# Before running disable all webhooks "update feature"
# --------------------------------------------------------

source devops_variables.sh

echo "Refresh All"

project_name='Modus Aha Integration Sandbox'
echo "${project_name}"



# Update "Custom.'${parent_id_name}'" field for all "Product Backlog Item"
backlog_items=$(az boards query --wiql "SELECT id, System.Parent, Custom.${parent_id_name} FROM workitems where [System.TeamProject] = '${project_name}' and [System.WorkItemType] = '${backlog_item_name}'")
# echo ${backlog_items} > teste1.json

count=0
for row_backlog_items in $(echo "${backlog_items}" | jq -r '.[] | @base64'); do
    _jq() {
    echo ${row_backlog_items} | base64 --decode | jq -r ${1}
    }
    backlog_id=$(_jq '.id')
    backlog_parent_id=$(_jq '.fields."System.Parent"')
    backlog_custom_parent_id=$(_jq '.fields."Custom.'${parent_id_name}'"')
    echo "backlog_id: ${backlog_id} / ${backlog_parent_id}" 
    if [ "${backlog_parent_id}" != "${backlog_custom_parent_id}" ]; then
        parent_id_update=$(az boards work-item update --id ${backlog_id} --fields "Custom.${parent_id_name}=${backlog_parent_id}" )
        count=$(($count + 1))
    fi
done
echo "backlog_items_updated: ${count}"



# Update "Custom.'${parent_id_name}'" field for all "Feature"
backlog_items=$(az boards query --wiql "SELECT id, System.Parent, Custom.${parent_id_name} FROM workitems where [System.TeamProject] = '${project_name}' and [System.WorkItemType] = '${feature_name}'")

count=0
for row_backlog_items in $(echo "${backlog_items}" | jq -r '.[] | @base64'); do
    _jq() {
    echo ${row_backlog_items} | base64 --decode | jq -r ${1}
    }
    backlog_id=$(_jq '.id')
    backlog_parent_id=$(_jq '.fields."System.Parent"')
    backlog_custom_parent_id=$(_jq '.fields."Custom.'${parent_id_name}'"')
    echo "backlog_id: ${backlog_id} / ${backlog_parent_id}" 
    if [ "${backlog_parent_id}" != "${backlog_custom_parent_id}" ]; then
        parent_id_update=$(az boards work-item update --id ${backlog_id} --fields "Custom.${parent_id_name}=${backlog_parent_id}" )
        count=$(($count + 1))
    fi
done
echo "features_updated: ${count}"



# Update TotalEffort, CompletedEffort, PercentageCompletedEffort, StartDate, TargetDate fields for all "Features"
features=$(az boards query --wiql "SELECT id, System.TeamProject FROM workitems where [System.TeamProject] = '${project_name}' and [System.WorkItemType] = '${feature_name}'")

chmod +x devops_effort_update_feature.sh
chmod +x devops_date_update_feature.sh

count=0
for row_features in $(echo "${features}" | jq -r '.[] | @base64'); do
    _jq() {
    echo ${row_features} | base64 --decode | jq -r ${1}
    }
    feature_id=$(_jq '.id')
    echo "FeatureId: ${feature_id}" 

    # before run this, disable all webhooks "update feature"
   ./devops_effort_update_feature.sh "${feature_id}" "${project_name}"
   ./devops_date_update_feature.sh "${feature_id}" "${project_name}"
   count=$(($count + 1))
done
echo "Features updated: ${count}"



# Update TotalEffort, CompletedEffort, PercentageCompletedEffort, StartDate, TargetDate fields for all "Epics"
epics=$(az boards query --wiql "SELECT id, System.TeamProject FROM workitems where [System.TeamProject] = '${project_name}' and [System.WorkItemType] = '${epic_name}'")

chmod +x devops_effort_date_update_epic.sh

count=0
for row_epics in $(echo "${epics}" | jq -r '.[] | @base64'); do
    _jq() {
    echo ${row_epics} | base64 --decode | jq -r ${1}
    }
    epic_id=$(_jq '.id')
    echo "EpicId: ${epic_id}" 

    ./devops_effort_date_update_epic.sh "${epic_id}" "${project_name}"
    count=$(($count + 1))
done
echo "Epics updated: ${count}"

