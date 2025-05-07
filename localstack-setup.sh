#!/bin/bash

echo "Creating SQS..."

awslocal sqs create-queue --queue-name $PRODUCAO_SQS_NAME

