variable "aws_region" {}
variable "access_key" {}
variable "secret_key" {}
variable "key_name" {}
variable "private_ip" {}
variable "operator_group" {}
variable "operator_user" {}
variable "operator_password" {}
variable "mysql_root_password" {}
variable "mysql_app_user" {}
variable "mysql_app_user_password" {}
variable "ssh_security_group_name" {}
variable "outbound_security_group_name" {}
variable "wow_vanilla_security_group_name" {}
variable "docker_instance_name" {}
variable "client_data_s3_bucket_name" {
  description = "Name of the s3 bucket to retrieve the client data"
}
