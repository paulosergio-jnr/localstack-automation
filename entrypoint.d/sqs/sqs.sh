#!/bin/bash

create_queues() {
  for QUEUE_FILE in "${QUEUE_FILES[@]}"; do
    echo -e "Creating queue from file [$QUEUE_FILE]"
    awslocal sqs create-queue --cli-input-json file://"$QUEUE_FILE" >>/dev/null
  done

  echo -e "Created queues: "
  awslocal sqs list-queues
}

send_messages() {
  for MESSAGE_FILE in "${MESSAGE_FILES[@]}"; do
    echo -e "Sending message from file [$MESSAGE_FILE]"
    awslocal sqs send-message --cli-input-json file://"$MESSAGE_FILE" >>/dev/null
  done
}

echo -e "+------------------------+"
echo -e "| Creating SQS workloads |"
echo -e "+------------------------+"

BASE_PATH=/docker-entrypoint-initaws.d
QUEUE_FILES=("$BASE_PATH"/sqs/queues/*.json)
MESSAGE_FILES=("$BASE_PATH"/sqs/messages/*.json)

if [ -e "${QUEUE_FILES[0]}" ]; then
  echo -e "Creating SQS queues..."
  create_queues
else
  echo -e "SQS queue scripts not found"
fi

echo -e ""

if [ -e "${MESSAGE_FILES[0]}" ]; then
  echo -e "Sending messages into SQS queues..."
  send_messages
else
  echo -e "SQS message scripts not found"
fi

echo -e "+---------------------------------+"
echo -e "| Finished SQS workloads creation |"
echo -e "+---------------------------------+"
echo -e ""
