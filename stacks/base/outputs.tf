output "compartment_ocid" {
  description = "OCID của compartment môi trường được tạo."
  value       = oci_identity_compartment.environment.id
}

output "vcn_ocid" {
  description = "OCID của VCN."
  value       = module.network.vcn_id
}

output "subnet_ocid" {
  description = "OCID của public subnet."
  value       = module.network.subnet_id
}

output "nsg_ocid" {
  description = "OCID của NSG dùng cho SSH."
  value       = module.network.nsg_id
}

output "instance_ids" {
  description = "Danh sách OCID của các instance."
  value       = module.compute.instance_ids
}

output "instance_public_ips" {
  description = "Danh sách địa chỉ IP công khai (nếu có)."
  value       = module.compute.instance_ips
}

output "identity_domain_id" {
  description = "OCID của Identity Domain được tạo."
  value       = module.iam.identity_domain_id
}

output "dynamic_group_id" {
  description = "OCID của dynamic group gắn cho instance."
  value       = module.iam.dynamic_group_id
}

output "dynamic_group_matching_rule" {
  description = "Matching rule áp dụng cho dynamic group."
  value       = module.iam.dynamic_group_matching_rule
}