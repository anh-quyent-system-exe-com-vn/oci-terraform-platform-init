data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_id
}

locals {
  ad_names = [for ad in data.oci_identity_availability_domains.ads.availability_domains : ad.name]
}

resource "oci_core_instance" "this" {
  count               = var.instance_count
  compartment_id      = var.compartment_id
  availability_domain = local.ad_names[count.index % length(local.ad_names)]
  display_name        = format("${var.name_prefix}-vm-%02d", count.index + 1)
  shape               = var.instance_shape

  dynamic "shape_config" {
    for_each = can(regex("\\.Flex$", var.instance_shape)) ? [1] : []
    content {
      ocpus         = var.instance_ocpus
      memory_in_gbs = var.instance_memory_gbs
    }
  }

  create_vnic_details {
    subnet_id        = var.subnet_id
    nsg_ids          = var.nsg_ids
    assign_public_ip = var.assign_public_ip
    display_name     = "primaryvnic"
    hostname_label   = format("vm%02d", count.index + 1)
  }

  source_details {
    source_type = "image"
    source_id   = var.image_id
  }

  metadata = {
    ssh_authorized_keys = var.ssh_authorized_keys
  }

  freeform_tags = var.tags

  timeouts {
    create = "60m"
  }
}