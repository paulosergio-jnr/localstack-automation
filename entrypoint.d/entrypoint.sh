#!/bin/bash

echo -e "+--------------------------+"
echo -e "| Creating local workloads |"
echo -e "+--------------------------+"
echo -e ""

BASE_PATH=/docker-entrypoint-initaws.d

if [[ $SERVICES =~ dynamodb && -e "$BASE_PATH/dynamodb" ]]; then
  bash $BASE_PATH/dynamodb/dynamodb.sh
fi

if [[ $SERVICES =~ sqs && -e "$BASE_PATH/sqs" ]]; then
  bash $BASE_PATH/sqs/sqs.sh
fi

if [[ $SERVICES =~ sns && -e "$BASE_PATH/sns" ]]; then
  bash $BASE_PATH/sns/sns.sh
fi

echo -e ""
echo -e "+-----------------------------+"
echo -e "| Finished workloads creation |"
echo -e "+-----------------------------+"
