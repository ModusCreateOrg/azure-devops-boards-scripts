#!/bin/bash

echo "*** Date Update"

source devops_get_parent_id.sh

#chmod +x devops_date_update_feature.sh
./devops_date_update_feature.sh "${ParentId}" "${project_name}"

# If feature changed update previous feature
if [ $backlog_item_moved = 1 ]; then
    ./devops_date_update_feature.sh "${CustomParentId}" "${project_name}"
fi
