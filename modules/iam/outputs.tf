output "identity_domain_id" {
  description = "OCID của Identity Domain được tạo."
  value       = oci_identity_domain.this.id
}

output "dynamic_group_id" {
  description = "OCID của dynamic group gắn với các instance."
  value       = oci_identity_dynamic_group.instances.id
}

output "dynamic_group_matching_rule" {
  description = "Matching rule áp dụng cho dynamic group."
  value       = oci_identity_dynamic_group.instances.matching_rule
}