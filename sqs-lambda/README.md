# Testing cross-account SQS to Lambda setup

This repository contains a simple example of how to set up an SQS queue that triggers a Lambda function in a different account, using event source mappings.

LocalStack supports cross-account setup that allows you to namespace resources based on the AWS Account ID. In this example, you can use two local AWS accounts to simulate the cross-account setup. They are:

- **Account A** (`111111111111`): The account where the Lambda function and the event source mapping is defined.
- **Account B** (`222222222222`): The account where the SQS queue is defined.

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html) & [`awslocal`](https://github.com/localstack/awscli-local)
- [LocalStack](https://docs.localstack.cloud/getting-started/installation/)

Start LocalStack with the following command:

```bash
DEBUG=1 localstack start
```

You can follow the instructions below or run the whole sample using the provided `run.sh` script.

```bash
./run.sh
```

## Create the Lambda function

Open a terminal and provide the following `AWS_ACCOUNT_ID` and `AWS_SECRET_ACCESS_KEY` environment variables:

```bash
export AWS_SECRET_ACCESS_KEY=test
export AWS_ACCESS_KEY_ID=111111111111
```

Run the following commands to create the Lambda function:

```bash
zip function.zip index.mjs

awslocal lambda create-function \
    --function-name CrossAccountSQSExample \
    --zip-file fileb://function.zip \
    --handler index.handler \
    --runtime nodejs18.x \
    --role arn:aws:iam::111111111111:role/cross-account-lambda-sqs-role
```

## Invoke the Lambda function

You can invoke the Lambda function using a `input.txt` file which simulates the event payload:

```bash
awslocal lambda invoke --function-name CrossAccountSQSExample \
    --payload file://input.txt outputfile.txt
```

The output will be written to the `outputfile.txt` file.

## Create the SQS queue

Open another terminal and provide the following `AWS_ACCOUNT_ID` and `AWS_SECRET_ACCESS_KEY` environment variables:

```bash
export AWS_SECRET_ACCESS_KEY=test
export AWS_ACCESS_KEY_ID=222222222222
```

Create the SQS queue:

```bash
awslocal sqs create-queue --queue-name LambdaCrossAccountQueue
```

## Create the event source mapping

Run the following command to create the event source mapping:

```bash
awslocal lambda create-event-source-mapping \
    --function-name CrossAccountSQSExample \
    --batch-size 10 \
    --event-source-arn arn:aws:sqs:us-east-1:222222222222:LambdaCrossAccountQueue
```

## Send a message to the SQS queue

You can send a message to the SQS queue using the following command:

```bash
awslocal sqs send-message \
    --queue-url 'http://sqs.us-east-1.localhost.localstack.cloud:4566/222222222222/LambdaCrossAccountQueue' \
    --message-body 'Hello World!'
```

You can navigate to the LocalStack logs to view the Lambda function's output.

```bash
2024-05-13T07:35:28.790 DEBUG --- [455d158f9165] l.s.l.i.version_manager    : [CrossAccountSQSExample-d07c16eb-531d-4458-bff1-455d158f9165] 2024-05-13T07:35:28.759Z	d07c16eb-531d-4458-bff1-455d158f9165	INFO	Hello World!
```
