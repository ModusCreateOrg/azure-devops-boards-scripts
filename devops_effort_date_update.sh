#!/bin/bash

echo "*** Effort Date Update"

source devops_get_parent_id.sh

#chmod +x devops_effort_date_update_epic.sh
./devops_effort_date_update_epic.sh "${ParentId}" "${project_name}"

# If feature changed update previous feature
if [ $backlog_item_moved = 1 ]; then
    ./devops_effort_date_update_epic.sh "${CustomParentId}" "${project_name}"
fi
