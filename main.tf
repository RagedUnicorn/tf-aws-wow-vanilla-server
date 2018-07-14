# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Deploy a docker ec2 instance for running a mangos based Vanilla World of Warcraft server
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

###############
# AWS provider
###############
provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.aws_region}"
}

###################################
# Module user-data template script
###################################
data "template_file" "init" {
  template = "${file("${path.module}/templates/instance-entrypoint.tpl")}"

  vars {
    operator_user           = "${var.operator_user}"
    operator_password       = "${var.operator_password}"
    mysql_root_password     = "${var.mysql_root_password}"
    mysql_app_user          = "${var.mysql_app_user}"
    mysql_app_user_password = "${var.mysql_app_user_password}"
  }
}

module "server" {
  # source     = "github.com/ragedunicorn/terraform-aws-rg-docker"
  source = "../terraform-aws-rg-docker"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  aws_region = "${var.aws_region}"

  security_groups = [
    "${aws_security_group.ssh.id}",
    "${aws_security_group.outbound.id}",
    "${aws_security_group.wow_vanilla.id}"
  ]

  instance_entrypoint = "${data.template_file.init.rendered}"
  key_name            = "${var.key_name}"
  operator_user       = "${var.operator_user}"
  operator_group      = "${var.operator_group}"
  operator_password   = "${var.operator_password}"
}

##################
# Security groups
##################
resource "aws_security_group" "ssh" {
  name        = "${var.ssh_security_group_name}"
  description = "Default security group with ssh access for any ip-address"

  # ssh
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "outbound" {
  name        = "${var.outbound_security_group_name}"
  description = "Default security group for outbound tcp traffic"

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "wow_vanilla" {
  name        = "${var.wow_vanilla_security_group_name}"
  description = "Allow incoming traffic to realmd and mangosd"

  # Allow inbound for mangosd
  ingress {
    from_port   = 8085
    to_port     = 8085
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow inbound for realmd
  ingress {
    from_port   = 3724
    to_port     = 3724
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
