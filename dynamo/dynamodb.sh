#!/bin/bash

create_tables()
{
  for SCHEMA_FILE in ./schemas/*.json
  do
    echo -e "Executando arquivo $SCHEMA_FILE..."
    aws dynamodb create-table --cli-input-json file://"$SCHEMA_FILE" --endpoint-url http://localhost:4566 >> /dev/null
  done
}

insert_into_tables()
{
  for DATA_FILE in ./data/*.json
  do
    echo -e "Executando arquivo $DATA_FILE..."
    aws dynamodb put-item --cli-input-json file://"$DATA_FILE" --endpoint-url http://localhost:4566 >> /dev/null
  done
}

echo -e "******************************************"
echo -e "* Iniciando criação de recursos DynamoDB *"
echo -e "******************************************"

SCHEMAS_PATTERN=(./schemas/*.json)
DATA_PATTERN=(./data/*.json)

if [ -e "${SCHEMAS_PATTERN[0]}" ]; then
  echo -e "Iniciando criação de tabelas..."
  create_tables
else
  echo -e "Scripts de criação de tabelas não encontrados"
fi


if [ -e "${DATA_PATTERN[0]}" ]; then
  echo -e "Iniciando insercão de dados..."
  insert_into_tables
else
  echo -e "Scripts de inserção de dados não encontrados"
fi

echo -e "*******************************************************"
echo -e "* Processo de criação de recursos DynamoDB finalizado *"
echo -e "*******************************************************"
