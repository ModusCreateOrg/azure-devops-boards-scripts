#!/bin/bash

echo "*** Effort Update"

source devops_get_parent_id.sh

chmod +x devops_effort_update_feature.sh
./devops_effort_update_feature.sh "${ParentId}" "${project_name}"

# If feature changed update previous feature
if [ $backlog_item_moved = 1 ]; then
    ./devops_effort_update_feature.sh "${CustomParentId}" "${project_name}"
fi
