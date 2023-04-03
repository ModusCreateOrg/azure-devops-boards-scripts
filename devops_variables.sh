#!/bin/bash

az devops configure --defaults "organization=$ORGANIZATION"

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