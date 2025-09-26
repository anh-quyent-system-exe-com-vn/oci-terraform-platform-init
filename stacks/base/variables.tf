variable "parent_compartment_ocid" {
  description = "OCID của compartment cha chứa các compartment con."
  type        = string
}

variable "tenancy_ocid" {
  description = "OCID của tenancy (dùng để tra cứu availability domains)."
  type        = string
}

variable "region" {
  description = "OCI region (vd: ap-tokyo-1)."
  type        = string
  default     = "ap-tokyo-1"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.region))
    error_message = "Region phải ở dạng chữ thường, số và dấu gạch ngang (vd: ap-tokyo-1)."
  }
}

variable "project" {
  description = "Tên dự án để prefix tài nguyên."
  type        = string
  default     = "tfexample"
}

variable "environment" {
  description = "Tên môi trường (dev/stg/prod hoặc custom)."
  type        = string
  default     = "base"
}

variable "vcn_cidr" {
  description = "CIDR cho VCN."
  type        = string
  default     = "10.1.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR cho public subnet."
  type        = string
  default     = "10.1.20.0/24"
}

variable "assign_public_ip" {
  description = "Bật/tắt gán địa chỉ IP công khai cho VM."
  type        = bool
  default     = true
}

variable "ssh_public_key" {
  description = "SSH public key để inject vào instance (nên đặt trong tfvars)."
  type        = string
  sensitive   = true
}

variable "instance_count" {
  description = "Số lượng instance cần tạo."
  type        = number
  default     = 1

  validation {
    condition     = var.instance_count >= 1 && var.instance_count <= 20
    error_message = "instance_count nên trong khoảng 1..20."
  }
}

variable "instance_shape" {
  description = "OCI Compute shape (vd: VM.Standard.E5.Flex)."
  type        = string
  default     = "VM.Standard.E5.Flex"
}

variable "instance_ocpus" {
  description = "Số OCPU cho shape Flex."
  type        = number
  default     = 1
}

variable "instance_memory_gbs" {
  description = "RAM (GB) cho shape Flex."
  type        = number
  default     = 6
}

variable "image_ocid" {
  description = "Map region->Image OCID."
  type        = map(string)
  default = {
    ap-tokyo-1 = "ocid1.image.oc1.ap-tokyo-1.aaaaaaaa3plsyjta56qjv4ntlwwb3uvwt6tcqymfi6slnsobiuqkdbzlk3ja"
  }
}

variable "domain_display_name" {
  description = "Display name cho Identity Domain (để trống sẽ tự sinh từ prefix)."
  type        = string
  default     = null
}

variable "domain_description" {
  description = "Mô tả cho Identity Domain."
  type        = string
  default     = null
}

variable "domain_license_type" {
  description = "License type của Identity Domain (FREE, PREMIUM,...)."
  type        = string
  default     = "FREE"
}

variable "domain_type" {
  description = "Loại Identity Domain (DEFAULT, ADMINISTRATIVE,...)."
  type        = string
  default     = "DEFAULT"
}

variable "domain_admin_email" {
  description = "Email quản trị viên cho Identity Domain."
  type        = string
}

variable "custom_matching_rule" {
  description = "Matching rule tuỳ chỉnh cho dynamic group (nếu đặt sẽ ghi đè auto-generated)."
  type        = string
  default     = null
}

variable "dynamic_group_name" {
  description = "Tên dynamic group (để trống sẽ tự sinh từ prefix)."
  type        = string
  default     = null
}

variable "dynamic_group_description" {
  description = "Mô tả dynamic group."
  type        = string
  default     = null
}