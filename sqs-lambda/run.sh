#!/bin/bash

export AWS_SECRET_ACCESS_KEY=test

# Terminal 1

zip function.zip index.mjs

AWS_ACCESS_KEY_ID=111111111111 awslocal lambda create-function \
    --function-name CrossAccountSQSExample \
    --zip-file fileb://function.zip \
    --handler index.handler \
    --runtime nodejs18.x \
    --role arn:aws:iam::111111111111:role/cross-account-lambda-sqs-role

AWS_ACCESS_KEY_ID=111111111111 awslocal lambda wait function-active-v2 --function-name CrossAccountSQSExample

AWS_ACCESS_KEY_ID=111111111111 awslocal lambda invoke --function-name CrossAccountSQSExample \
    --payload file://input.txt outputfile.txt

# Terminal 2

AWS_ACCESS_KEY_ID=222222222222 awslocal sqs create-queue --queue-name LambdaCrossAccountQueue

# Terminal 1

AWS_ACCESS_KEY_ID=111111111111 awslocal lambda create-event-source-mapping \
    --function-name CrossAccountSQSExample \
    --batch-size 10 \
    --event-source-arn arn:aws:sqs:us-east-1:222222222222:LambdaCrossAccountQueue

# Terminal 2

AWS_ACCESS_KEY_ID=222222222222 awslocal sqs send-message \
    --queue-url 'http://sqs.us-east-1.localhost.localstack.cloud:4566/222222222222/LambdaCrossAccountQueue' \
    --message-body 'Hello World!'
