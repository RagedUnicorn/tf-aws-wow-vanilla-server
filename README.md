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
| secret_key                      |             | string | -       | yes      |
| private_ip                      |             | string | -       | yes      |
| key_name                        |             | string | -       | yes      |
| docker_instance_name            |             | string | -       | yes      |
| mysql_app_user                  |             | string | -       | yes      |
| mysql_app_user_password         |             | string | -       | yes      |
| mysql_root_password             |             | string | -       | yes      |
| operator_group                  |             | string | -       | yes      |
| operator_password               |             | string | -       | yes      |
| operator_user                   |             | string | -       | yes      |
| outbound_security_group_name    |             | string | -       | yes      |
| ssh_security_group_name         |             | string | -       | yes      |
| wow_vanilla_security_group_name |             | string | -       | yes      |

## Outputs

| Name                        | Description                                                |
|-----------------------------|------------------------------------------------------------|
| availability_zone           | Availability zone of the created instance                  |
| generated_ansible_playbook  | The rendered ansible playbook                              |
| generated_cloud_config      | The rendered cloudinit config                              |
| generated_cloud_init_config | The rendered cloud-init config                             |
| id                          | ID of the created instance                                 |
| key_name                    | Key name of the created instance                           |
| public_ip                   | The public IP of the created ec2 instance                  |
| security_groups             | List of associated security groups of the created instance |
| tags                        | List of tags for the created instance                      |

## Creates

### CloudWatch Events

Create event triggers for both starting and stopping the EC2 server.

#### Start server

Starts the server every evening by invoking the lambda function `RGTFStartStopWoWVanillaServer`.

#### Stop server

Stops the EC2 server at midnight by invoking the lambda function `RGTFStartStopWoWVanillaServer`.

**Note:** Cloudwatch cron expressions work with GMT time. Times should be adjusted accordingly.

### DNS

Creates an A record for the EC2 server. This has a dependency on a previously created host zone.

`wow-vanilla.ragedunicorn.com - [EIP]`

Dependency on host zone `ragedunicorn.com`

Propagation of a new record can take some time. Test with nslookup:

```
 nslookup wow-vanilla.ragedunicorn.com
 ```
