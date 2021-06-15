#!/bin/bash

create_topics() {
  for TOPIC_FILE in "${TOPIC_FILES[@]}"; do
    echo -e "Creating topic from file [$TOPIC_FILE]"
    awslocal sns create-topic --cli-input-json file://"$TOPIC_FILE" >> /dev/null
  done

  echo -e "Created topics: "
  awslocal sns list-topics
}

create_subscriptions() {
  for SUBSCRIBERS_FILE in "${SUBSCRIBERS_FILES[@]}"; do
    echo -e "Creating subscription from file [$SUBSCRIBERS_FILE]"
    awslocal sns subscribe --cli-input-json file://"$SUBSCRIBERS_FILE" >> /dev/null
  done
}

publish_events() {
  for EVENT_FILE in "${EVENT_FILES[@]}"; do
    echo -e "Sending event from file [$EVENT_FILE]"
    awslocal sns publish --cli-input-json file://"$EVENT_FILE" >> /dev/null
  done
}

echo -e "+------------------------+"
echo -e "| Creating SNS workloads |"
echo -e "+------------------------+"

BASE_PATH=/docker-entrypoint-initaws.d
TOPIC_FILES=("$BASE_PATH"/sns/topics/*.json)
SUBSCRIBERS_FILES=("$BASE_PATH"/sns/subscriptions/*.json)
EVENT_FILES=("$BASE_PATH"/sns/events/*.json)

if [ -e "${TOPIC_FILES[0]}" ]; then
  echo -e "Creating SNS topics..."
  create_topics
else
  echo -e "SNS topic scripts not found"
fi

echo -e ""

if [ -e "${SUBSCRIBERS_FILES[0]}" ]; then
  echo -e "Creating SNS subscriptions..."
  create_subscriptions
else
  echo -e "SNS subscription scripts not found"
fi

echo -e ""

if [ -e "${EVENT_FILES[0]}" ]; then
  echo -e "Sending events into SNS topics..."
  publish_events
else
  echo -e "SNS event scripts not found"
fi

echo -e "+---------------------------------+"
echo -e "| Finished SNS workloads creation |"
echo -e "+---------------------------------+"
echo -e ""
