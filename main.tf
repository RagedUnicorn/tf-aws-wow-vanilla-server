# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Deploy a docker ec2 instance for running a mangos based Vanilla World of Warcraft server
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#############
# S3 Backend
#############
terraform {
  backend "s3" {
    bucket = "rg-tf-wow-vanilla-server"
    key    = "wow-vanilla-server.terraform.tfstate"
    region = "eu-central-1"
  }
}

###############
# AWS provider
###############
provider "aws" {
  version    = "~> 1.31"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.aws_region}"
}

####################
# Template provider
####################
provider "template" {
  version = "~> 1.0"
}

###################################
# Module user-data template script
###################################
data "template_file" "instance-entrypoint" {
  template = "${file("${path.module}/templates/instance-entrypoint.tpl")}"

  vars {
    operator_user              = "${var.operator_user}"
    operator_password          = "${var.operator_password}"
    mysql_root_password        = "${var.mysql_root_password}"
    mysql_app_user             = "${var.mysql_app_user}"
    mysql_app_user_password    = "${var.mysql_app_user_password}"
    client_data_s3_bucket_name = "${var.client_data_s3_bucket_name}"
    user_extra_data            = "${base64encode("${file("${path.module}/templates/user-data.tar.gz")}")}"
  }
}

module "server" {
  source     = "github.com/ragedunicorn/terraform-aws-rg-docker?ref=v1.1.0"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  aws_region = "${var.aws_region}"

  security_groups = [
    "${aws_security_group.ssh.id}",
    "${aws_security_group.outbound.id}",
    "${aws_security_group.wow_vanilla.id}",
  ]

  docker_instance_name = "${var.docker_instance_name}"
  instance_entrypoint  = "${data.template_file.instance-entrypoint.rendered}"
  private_ip           = "${var.private_ip}"
  subnet_id            = "${aws_subnet.subnet.id}"
  key_name             = "${var.key_name}"
  operator_user        = "${var.operator_user}"
  operator_group       = "${var.operator_group}"
  operator_password    = "${var.operator_password}"
}
