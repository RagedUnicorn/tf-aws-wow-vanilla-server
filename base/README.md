# wow-vanilla-server

> Module for wow-vanilla-server

A module for creating the basic resources such as S3 bucket for storing terraform state and IAM users.

## Link

[tf-aws-wow-vanilla-server](https://github.com/RagedUnicorn/tf-aws-wow-vanilla-server)

## Inputs

| Name       | Description        | Type   | Default        | Required |
|------------|--------------------|--------|----------------|----------|
| access_key | The AWS access key | string | -              | yes      |
| aws_region | AWS region         | string | `eu-central-1` | no       |
| secret_key | The AWS secret key | string | -              | yes      |

## Outputs

#### S3 Bucket

```
terraform {
  backend "s3" {
    bucket = "rg-tf-wow-vanilla-server"
    key    = "wow-vanilla-server.terraform.tfstate"
    region = "eu-central-1"
  }
}
```

| Name               | Description                            |
|--------------------|----------------------------------------|
| id                 | ID of the created bucket               |
| arn                | The ARN of the bucket.                 |
| bucket_domain_name | The bucket domain name.                |
| region             | The AWS region this bucket resides in. |

#### IAM deployer user

`rg_cli_tf_wow_vanilla_server_deployer`

| Name               | Description                            |
|--------------------|----------------------------------------|
| arn                | The ARN assigned by AWS for this user. |
| name               | The user's name.                       |
| unique_id          | The unique ID assigned by AWS.         |
| access_key         | The AWS access key.                    |
| secret_key         | The AWS secret key.                    |
