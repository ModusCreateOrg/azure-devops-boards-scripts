#!/bin/bash

echo "*** Get ParentId"

source devops_variables.sh

JsonPost=$(cat JsonPost.json)

eventType=$(echo "${JsonPost}" | jq '.eventType')
if [[ ${eventType} = '"workitem.updated"' ]]; then
    CurrentId=$(echo "${JsonPost}" | jq '.resource.workItemId')
else
    CurrentId=$(echo "${JsonPost}" | jq '.resource.id')
fi

echo "eventType: ${eventType}"
echo "CurrentId: ${CurrentId}"

# if CurrentId is not a number, exit
re='^[0-9]+$'
if [[ ${CurrentId} =~ $re ]] ; then

    backlog_item_moved=0
    if [ ${eventType} = '"workitem.updated"' ]; then
        ParentId=$(echo "${JsonPost}" | jq '.resource.revision.fields."System.Parent"')
        CustomParentId=$(echo "${JsonPost}" | jq '.resource.revision.fields."Custom.'${parent_id_name}'"')

        re='^[0-9]+$'
        if [[ ! ${CustomParentId} =~ $re ]] ; then
            CustomParentId=$(az boards query --wiql "SELECT ${parent_id_name} FROM workitems where id = ${CurrentId}" | jq -r '.[0] | .fields."Custom.'${parent_id_name}'"')
        fi

        # Check if feature was changed 
        if [ ${ParentId} != ${CustomParentId} ]; then
            backlog_item_moved=1
            parent_id_update=$(az boards work-item update --id ${CurrentId} --fields "Custom.${parent_id_name}=${ParentId}" )
        fi

    elif [ ${eventType} = '"workitem.created"' ]; then
        # Get ParentId from "New item"
        ParentId=$(echo "${JsonPost}" | jq '.resource.fields."System.Parent"')
        
        if [[ ${ParentId} =~ $re ]] ; then
            parent_id_update=$(az boards work-item update --id ${CurrentId} --fields "Custom.${parent_id_name}=${ParentId}" )
        fi

    elif [ "${eventType}" = '"workitem.deleted"' ]; then
        # Get ParentId from "Deleted Item"
        ParentId=$(echo "${JsonPost}" | jq '.resource.fields."Custom.'${parent_id_name}'"')

    else
        echo "eventType: ${eventType}"
        echo "eventType missing"
        exit 1
    fi


    if ! [[ ${ParentId} =~ $re ]] ; then
        echo "ParentId not a number"
        exit 1
    fi

else
    echo "CurrentId not a number"
    exit 1
fi

if [ ${eventType} = '"workitem.updated"' ]; then
    project_name=$(echo "${JsonPost}" | jq -r '.resource.revision.fields."System.TeamProject"')
else
    project_name=$(echo "${JsonPost}" | jq -r '.resource.fields."System.TeamProject"')
fi

echo "A feature_changed: ${backlog_item_moved}"
echo "A ParentId: ${ParentId}"
echo "A CustomParentId: ${CustomParentId}"
echo "A Project Name: ${project_name}"

