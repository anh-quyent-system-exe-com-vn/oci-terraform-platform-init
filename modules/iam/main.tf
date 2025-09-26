resource "oci_identity_domain" "this" {
  compartment_id = var.domain_compartment_id
  display_name   = local.domain_display_name
  description    = local.domain_description
  home_region    = var.home_region
  license_type   = var.domain_license_type
  admin_email    = var.domain_admin_email
  freeform_tags  = var.tags
}

resource "oci_identity_dynamic_group" "instances" {
  compartment_id = var.tenancy_id
  name           = local.dynamic_group_name
  description = coalesce(
    var.dynamic_group_description,
    format("Dynamic group for instances in %s", var.name_prefix)
  )
  matching_rule = local.dynamic_group_matching_rule
  freeform_tags = var.tags

  lifecycle {
    precondition {
      condition     = trimspace(coalesce(local.dynamic_group_matching_rule, "")) != ""
      error_message = "Dynamic group matching rule không được để trống. Hãy cung cấp instance_ids hoặc custom_matching_rule."
    }
  }
}

resource "oci_identity_policy" "dynamic_group" {
  compartment_id = local.policy_compartment_id
  name           = local.policy_name
  description    = local.policy_description
  statements     = local.policy_statements
  freeform_tags  = var.tags

  depends_on = [oci_identity_dynamic_group.instances]
}
