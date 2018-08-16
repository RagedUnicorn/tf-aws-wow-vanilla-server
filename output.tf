output "id" {
  description = "ID of the created instance"
  value       = "${module.server.id}"
}

output "availability_zone" {
  description = "Availability zone of the created instance"
  value       = "${module.server.availability_zone}"
}

output "key_name" {
  description = "Key name of the created instance"
  value       = "${module.server.key_name}"
}

output "security_groups" {
  description = "List of associated security groups of the created instance"
  value       = ["${module.server.security_groups}"]
}

output "tags" {
  description = "List of tags for the created instance"
  value       = ["${module.server.tags}"]
}

output "generated_cloud_config" {
  description = "The rendered cloudinit config"
  value       = "${module.server.generated_cloud_config}"
}

output "generated_cloud_init_config" {
  description = "The rendered cloud-init config"
  value       = "${module.server.generated_cloud_init_config}"
}

output "generated_ansible_playbook" {
  description = "The rendered ansible playbook"
  value       = "${module.server.generated_ansible_playbook}"
}

output "eip_public_ip" {
  description = "The public Elastic IP address"
  value       = "${aws_eip.elastic_ip.public_ip}"
}

output "api_gateway_base_url" {
  description = "The Api Gateway base url"
  value       = "${aws_api_gateway_deployment.deployment.invoke_url}"
}

output "api_gateway_start_server_url" {
  description = "The Api Gateway start url"
  value       = "${aws_api_gateway_deployment.deployment.invoke_url}?action=start&region=${var.aws_region}&instanceId=${module.server.id}"
}

output "api_gateway_stop_server_url" {
  description = "The Api Gateway stop url"
  value       = "${aws_api_gateway_deployment.deployment.invoke_url}?action=stop&region=${var.aws_region}&instanceId=${module.server.id}"
}
