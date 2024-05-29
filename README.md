# Samples for testing AWS cross-account & cross-region applications on LocalStack

LocalStack automatically namespaces all resources based on the account ID and, in some cases, the region. However, there are certain resource types that can be accessed across multiple accounts or regions. This repository contains sample code and configuration files to test cross-account and cross-region applications on LocalStack.

## Pre-requisites

- [Docker](https://docs.docker.com/get-docker/)
- [`localstack` CLI](https://docs.localstack.cloud/getting-started/installation/#localstack-cli) with [`LOCALSTACK_AUTH_TOKEN`](https://docs.localstack.cloud/getting-started/auth-token/)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html) with [`awslocal`](https://docs.localstack.cloud/user-guide/integrations/aws-cli/#localstack-aws-cli-awslocal)

## Enabling IAM Enforcement

While running these samples, it is suggested to enable IAM Enforcement via `ENFORCE_IAM=1` while starting LocalStack. This will ensure that the IAM policies are enforced for the resources created in LocalStack, and you can reliably test your policies associated with cross-account and cross-region applications, in a scenario similar to the AWS environment.

## Samples

| Sample | Description |
| --- | --- |
| [SQS, S3 & Lambda setup](sqs-s3-apigw-lambda) | A sample setup to demonstrate cross-account and cross-region access between SQS, S3, and Lambda. |
| [Step Functions & Lambda setup](stefunctions-lambda) | A sample setup to demonstrate the setup of a Step Functions state machine that invokes a Lambda function in a different account. |

## Checking out a single sample

To check out a single sample, you can use the following commands:

```bash
mkdir samples-cross-account-cross-region-testing && cd samples-cross-account-cross-region-testing
git init
git remote add origin -f git@github.com:localstack-samples/samples-cross-account-cross-region-testing.git
git config core.sparseCheckout true
echo <LOCALSTACK_SAMPLE_DIRECTORY_NAME> >> .git/info/sparse-checkout
git pull origin main
```

The above commands use `sparse-checkout` to only pull the sample you are interested in. You can find the name of the sample directory in the table above.
