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
time_zone="$TIME_ZONE"

states_not_started="$STATES_NOT_STARTED"
states_not_started_set_status="$STATES_NOT_STARTED_SET_STATUS"
states_in_development="$STATES_IN_DEVELOPMENT"
states_in_development_set_status="$STATES_IN_DEVELOPMENT_SET_STATUS"
states_resolved="$STATES_RESOLVED"
states_resolved_set_status="$STATES_RESOLVED_SET_STATUS"
states_closed="$STATES_CLOSED"
states_closed_set_status="$STATES_CLOSED_SET_STATUS"
states_blocked="$STATES_BLOCKED"
states_blocked_set_status="$STATES_BLOCKED_SET_STATUS"

# backlog_item_name="Product Backlog Item"
# feature_name="Feature"
# epic_name="Epic"
# state_done_name="Done"
# effort_name="Effort"
# parent_id_name="ParentId"
# completed_effort_name="CompletedEffort"
# percentage_completed_effort_name="PercentageCompletedEffort"
# time_zone="Z"

# states_not_started=("New" "Approved")
# states_not_started_set_status="New"
# states_in_development=("Committed")
# states_in_development_set_status="In Progress"
# states_resolved=("Ready for QA" "QA Done")
# states_resolved_set_status="Resolved"
# states_closed=("Done")
# states_closed_set_status="Done"
# states_blocked=("Removed")
# states_blocked_set_status=("Removed")
