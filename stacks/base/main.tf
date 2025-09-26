# Tạo compartment môi trường để chứa tất cả tài nguyên của environment hiện tại (vd: dev/stg/prod)
# - compartment_id: OCID của compartment cha (thường là tenancy hoặc một compartment cấp trên)
# - name: đặt theo convention "<project>-<environment>" giúp dễ quản lý theo môi trường
# - freeform_tags: gắn thẻ để truy vết nguồn quản lý (terraform) và phân loại
resource "oci_identity_compartment" "environment" {
  compartment_id = var.parent_compartment_ocid
  name           = "${var.project}-${var.environment}"
  description    = "Terraform managed compartment for ${var.environment} environment of project ${var.project}"
  freeform_tags  = local.tags
}

# Khởi tạo hạ tầng mạng cơ bản cho môi trường (VCN, Subnet, NSG, ...)
module "network" {
  source = "../../modules/network"

  # Triển khai tài nguyên mạng vào đúng compartment môi trường
  compartment_id = oci_identity_compartment.environment.id
  name_prefix    = local.name_prefix
  vcn_cidr       = var.vcn_cidr
  subnet_cidr    = var.public_subnet_cidr
  tags           = local.tags

  # Nhãn DNS ngắn gọn, tuân thủ giới hạn ký tự của OCI
  vcn_dns_label    = local.vcn_dns_label
  subnet_dns_label = local.subnet_dns_label
}

# Tạo các Compute Instance cho môi trường
module "compute" {
  source    = "../../modules/compute"
  providers = { oci = oci }

  # Tenancy để tra cứu ảnh, shape... theo region
  tenancy_id          = var.tenancy_ocid
  # Đặt instance vào compartment môi trường
  compartment_id      = oci_identity_compartment.environment.id
  name_prefix         = local.name_prefix
  # Gắn vào subnet và NSG được tạo trong module network
  subnet_id           = module.network.subnet_id
  nsg_ids             = [module.network.nsg_id]
  # Quy mô và cấu hình máy
  instance_count      = var.instance_count
  instance_shape      = var.instance_shape
  instance_ocpus      = var.instance_ocpus
  instance_memory_gbs = var.instance_memory_gbs
  assign_public_ip    = var.assign_public_ip
  # Image theo region
  image_id            = var.image_ocid[var.region]
  # Key SSH để đăng nhập
  ssh_authorized_keys = var.ssh_public_key
  tags                = local.tags
}

module "iam" {
  source    = "../../modules/iam"
  providers = { oci = oci }

  # Tenancy OCID: cần để tạo Dynamic Group/Policy ở cấp tenancy
  tenancy_id                = var.tenancy_ocid
  # Prefix để tạo tên tài nguyên IAM dễ theo dõi
  name_prefix               = local.name_prefix

  # Compartment nơi tạo Identity Domain (thường là compartment cha)
  domain_compartment_id     = var.parent_compartment_ocid

  # Compartment mục tiêu chứa tài nguyên (VCN/Compute/...) của môi trường
  target_compartment_id     = oci_identity_compartment.environment.id

  # Quan trọng: cấp quyền cho Dynamic Group QUẢN TRỊ tài nguyên trong đúng compartment môi trường
  # Module IAM sẽ sinh policy statement dạng:
  #   "Allow dynamic-group <dg-name> to manage all-resources in compartment id <env-compartment-ocid>"
  policy_compartment_id     = oci_identity_compartment.environment.id

  # Nếu không khai báo custom_matching_rule, module sẽ tự sinh matching_rule từ instance_ids
  instance_ids              = module.compute.instance_ids

  # Home region cho Identity Domain
  home_region               = var.region

  # Thông tin hiển thị/ mô tả cho Identity Domain (tuỳ chọn)
  domain_display_name       = var.domain_display_name
  domain_description        = var.domain_description
  domain_license_type       = var.domain_license_type
  domain_type               = var.domain_type
  domain_admin_email        = var.domain_admin_email

  # Dynamic Group: tên/mô tả và rule tuỳ chỉnh (nếu có)
  custom_matching_rule      = var.custom_matching_rule
  dynamic_group_name        = var.dynamic_group_name
  dynamic_group_description = var.dynamic_group_description

  tags                      = local.tags
}
