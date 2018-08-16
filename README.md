# tf-aws-wow-vanilla-server

> Terraform setup for running wow-vanilla-server application

## Architecture Overview

![wow-vanilla-server architecture](./docs/rg_wow_vanilla_server_overview.png "wow-vanilla-server architecture")

## Setup

### Credentials

Credentials can be setup in different ways. The modules within this repository either expects the credentials to be available via environment variables or supplied directly to terraform as variables.

```
export AWS_ACCESS_KEY_ID="[acceskey]"
export AWS_SECRET_ACCESS_KEY="[secretkey]"
export AWS_DEFAULT_REGION="eu-central-1"
```

Or directly

```
terraform apply -var 'access_key=[acceskey]' -var 'secret_key=[secretkey]'
```

If none of these are supplied terraform will ask for the variables interactively while preparing the setup

For more details see [documentation](https://www.terraform.io/docs/providers/aws/index.html).

### Deploy

Inside the application folder initialize and then apply the terraform configuration

```
# initialize terraform
terraform init

# check what terraform will create
terraform plan

# create resource
terraform apply
```

### Destroy

```
# destory resource
terraform destroy
```

## Inputs

| Name                            | Description | Type   | Default | Required |
|---------------------------------|-------------|--------|---------|----------|
| access_key                      |             | string | -       | yes      |
| aws_region                      |             | string | -       | yes      |
| docker_instance_name            |             | string | -       | yes      |
| key_name                        |             | string | -       | yes      |
| mysql_app_user                  |             | string | -       | yes      |
| mysql_app_user_password         |             | string | -       | yes      |
| mysql_root_password             |             | string | -       | yes      |
| operator_group                  |             | string | -       | yes      |
| operator_password               |             | string | -       | yes      |
| operator_user                   |             | string | -       | yes      |
| outbound_security_group_name    |             | string | -       | yes      |
| private_ip                      |             | string | -       | yes      |
| secret_key                      |             | string | -       | yes      |
| ssh_security_group_name         |             | string | -       | yes      |
| wow_vanilla_security_group_name |             | string | -       | yes      |

## Outputs

| Name                         | Description                                                |
|------------------------------|------------------------------------------------------------|
| api_gateway_base_url         | The Api Gateway base url                                   |
| api_gateway_start_server_url | The Api Gateway start url                                  |
| api_gateway_stop_server_url  | The Api Gateway stop url                                   |
| availability_zone            | Availability zone of the created instance                  |
| eip_public_ip                | The public Elastic IP address                              |
| generated_ansible_playbook   | The rendered ansible playbook                              |
| generated_cloud_config       | The rendered cloudinit config                              |
| generated_cloud_init_config  | The rendered cloud-init config                             |
| id                           | ID of the created instance                                 |
| key_name                     | Key name of the created instance                           |
| public_ip                    | The public IP of the created ec2 instance                  |
| security_groups              | List of associated security groups of the created instance |
| tags                         | List of tags for the created instance                      |

## Creates

### CloudWatch Events

Create event triggers for both starting and stopping the EC2 server.

#### Start server

Starts the server every evening by invoking the Lambda function `RGTFStartStopWoWVanillaServer`.

#### Stop server

Stops the EC2 server at midnight by invoking the Lambda function `RGTFStartStopWoWVanillaServer`.

**Note:** Cloudwatch cron expressions work with GMT time. Times should be adjusted accordingly.

### DNS

Creates an A record for the EC2 server. This has a dependency on a previously created host zone.

`wow-vanilla.ragedunicorn.com - [EIP]`

Dependency on host zone `ragedunicorn.com`

Propagation of a new record can take some time. Test with nslookup:

```
 nslookup wow-vanilla.ragedunicorn.com
 ```

### Lambda

Creates a Lambda function that can start and stop the EC2 server that is running the wow-server. The Lambda function can handle invocation from CloudWatch events and from the Api Gateway.

The Lambda function expects the following input

{
  "action": "", // start or stop
  "region": "eu-central-1",
  "instanceId": "" // instance id of the EC2 instance that gets started or stopped
}

#### Proxy response

The Api Gateway expects a proxy response from the Lambda function.

```
response = {
    "statusCode": 200,
    "body": json.dumps(data),
    "isBase64Encoded": False
};
return response
```

See [AWS documentation](https://aws.amazon.com/premiumsupport/knowledge-center/malformed-502-api-gateway/) for more details about proxy responses.

### API Gateway

Creates an Api for starting and stopping the EC2 instance by invoking the same Lambda function that is also used by CloudWatch.

The invoke url can be found by navigating to:

`https://eu-central-1.console.aws.amazon.com/apigateway/home`

`Choosing the API name > Stages > (Click) wow-vanilla-server`

###### Base URL

`[base-url]/wow-vanilla-server?action=[action]&region=[region]&instanceId=[instance-id]`

###### Start
`[base-url]/wow-vanilla-server?action=start&region=eu-central-1&instanceId=[instance-id]`

###### Stop
`[base-url]/wow-vanilla-server?action=stop&region=eu-central-1&instanceId=[instance-id]`
