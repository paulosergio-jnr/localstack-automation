#!/bin/bash

echo -e "+--------------------------+"
echo -e "| Creating local workloads |"
echo -e "+--------------------------+"
echo -e ""

BASE_PATH=/docker-entrypoint-initaws.d

if [ -e "$BASE_PATH/dynamodb" ]; then
  bash $BASE_PATH/dynamodb/dynamodb.sh
fi

echo -e ""
echo -e "+-----------------------------+"
echo -e "| Finished workloads creation |"
echo -e "+-----------------------------+"
