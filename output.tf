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

output "public_ip" {
  description = "The public IP of the created ec2 instance"
  value       = "${module.server.public_ip}"
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
  value = "${module.server.generated_cloud_config}"
}

output "generated_cloud_init_config" {
  description = "The rendered cloud-init config"
  value = "${module.server.generated_cloud_init_config}"
}

output "generated_ansible_playbook" {
  description = "The rendered ansible playbook"
  value = "${module.server.generated_ansible_playbook}"
}
