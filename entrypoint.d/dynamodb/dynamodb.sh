#!/bin/bash

create_tables() {
  for TABLE_FILE in $TABLE_FILES; do
    echo -e "Creating table from file [$TABLE_FILE]"
    awslocal dynamodb create-table --cli-input-json file://"$TABLE_FILE" >> /dev/null
  done
}

load_data() {
  for DATA_FILE in $DATA_FILES; do
    echo -e "Loading data from file [$DATA_FILE]"
    awslocal dynamodb put-item --cli-input-json file://"$DATA_FILE" >> /dev/null
  done
}

echo -e "+-----------------------------+"
echo -e "| Creating DynamoDB workloads |"
echo -e "+-----------------------------+"

BASE_PATH=/docker-entrypoint-initaws.d
TABLE_FILES=("$BASE_PATH"/dynamodb/schemas/*.json)
DATA_FILES=("$BASE_PATH"/dynamodb/data/*.json)

if [ -e "${TABLE_FILES[0]}" ]; then
  echo -e "Creating DynamoDB tables..."
  create_tables
else
  echo -e "DynamoDB table scripts not found"
fi

echo -e ""

if [ -e "${DATA_FILES[0]}" ]; then
  echo -e "Loading data into DynamoDB tables..."
  load_data
else
  echo -e "DynamoDB data load scripts not found"
fi

echo -e "+--------------------------------------+"
echo -e "| Finished DynamoDB workloads creation |"
echo -e "+--------------------------------------+"
