output "vcn_id" {
  description = "OCID of the created VCN."
  value       = oci_core_vcn.this.id
}

output "subnet_id" {
  description = "OCID of the created public subnet."
  value       = oci_core_subnet.public.id
}

output "nsg_id" {
  description = "OCID of the created SSH network security group."
  value       = oci_core_network_security_group.ssh.id
}

output "route_table_id" {
  description = "OCID of the public route table."
  value       = oci_core_route_table.public.id
}