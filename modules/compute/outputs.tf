output "instance_ids" {
  description = "List of OCIDs for the created instances."
  value       = [for instance in oci_core_instance.this : instance.id]
}

output "instance_ips" {
  description = "List of public IP addresses for the created instances."
  value       = [for instance in oci_core_instance.this : try(instance.public_ip, null)]
}
