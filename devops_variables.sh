#!/bin/bash

# Copy variables to file - to run the pipeline on docker
create_env_file=$1
if [[ "$create_env_file" == "1" ]]; then
    echo "AZURE_DEVOPS_EXT_PAT=$AZURE_DEVOPS_EXT_PAT" > env.list
    echo "ORGANIZATION=$ORGANIZATION" >> env.list
    echo "BACKLOG_ITEM_NAME=$BACKLOG_ITEM_NAME" >> env.list
    echo "FEATURE_NAME=$FEATURE_NAME" >> env.list
    echo "EPIC_NAME=$EPIC_NAME" >> env.list
    echo "STATE_DONE_NAME=$STATE_DONE_NAME" >> env.list
    echo "EFFORT_NAME=$EFFORT_NAME" >> env.list
    echo "PARENT_ID_NAME=$PARENT_ID_NAME" >> env.list
    echo "COMPLETED_EFFORT_NAME=$COMPLETED_EFFORT_NAME" >> env.list
    echo "PERCENTAGE_COMPLETED_EFFORT_NAME=$PERCENTAGE_COMPLETED_EFFORT_NAME" >> env.list
    echo "TOTAL_EFFORT_NAME=$TOTAL_EFFORT_NAME" >> env.list
    echo "TIME_ZONE=$TIME_ZONE" >> env.list
    echo "STATES_ENABLED=$STATES_ENABLED" >> env.list
    echo "STATES=$STATES" >> env.list
    #cat env.list
else
    az devops configure --defaults "organization=$ORGANIZATION"
fi

# Azure Library converts variables to uppercase
backlog_item_name="$BACKLOG_ITEM_NAME"
feature_name="$FEATURE_NAME"
epic_name="$EPIC_NAME"
state_done_name="$STATE_DONE_NAME"
effort_name="$EFFORT_NAME"
parent_id_name="$PARENT_ID_NAME"
completed_effort_name="$COMPLETED_EFFORT_NAME"
percentage_completed_effort_name="$PERCENTAGE_COMPLETED_EFFORT_NAME"
total_effort_name="$TOTAL_EFFORT_NAME"
time_zone="$TIME_ZONE"
states_enabled="$STATES_ENABLED"
states="$STATES"

# Variables example

# backlog_item_name="Product Backlog Item"
# feature_name="Feature"
# epic_name="Epic"
# state_done_name="Done"
# effort_name="Effort"
# parent_id_name="ParentId"
# completed_effort_name="CompletedEffort"
# percentage_completed_effort_name="PercentageCompletedEffort"
# time_zone="Z"

# States check file states.json