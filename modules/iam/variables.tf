variable "tenancy_id" {
  description = "OCID của tenancy (cần thiết cho dynamic group)."
  type        = string
}

variable "name_prefix" {
  description = "Prefix chung cho tài nguyên IAM."
  type        = string
}

variable "domain_compartment_id" {
  description = "Compartment OCID nơi tạo Identity Domain."
  type        = string
}

variable "target_compartment_id" {
  description = "Compartment OCID chứa các instance cần gán vào dynamic group."
  type        = string
}

variable "instance_ids" {
  description = "Danh sách OCID của các instance cần match."
  type        = list(string)
  default     = []

  validation {
    condition     = var.custom_matching_rule != null || length(var.instance_ids) > 0
    error_message = "Cần cung cấp instance_ids khi không khai báo custom_matching_rule."
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

variable "home_region" {
  description = "Home region cho Identity Domain."
  type        = string
}

variable "domain_license_type" {
  description = "Loại license của Identity Domain (FREE, PREMIUM...)."
  type        = string
  default     = "FREE"
}

variable "domain_type" {
  description = "Loại domain (DEFAULT, ADMINISTRATIVE...)."
  type        = string
  default     = "DEFAULT"
}

variable "domain_admin_email" {
  description = "Email quản trị viên cho Identity Domain."
  type        = string
  default     = null
}

variable "custom_matching_rule" {
  description = "Matching rule tuỳ chỉnh cho dynamic group (nếu đặt, bỏ qua auto-generated)."
  type        = string
  default     = null
}

variable "dynamic_group_name" {
  description = "Tên dynamic group (để trống sẽ tự sinh)."
  type        = string
  default     = null
}

variable "dynamic_group_description" {
  description = "Mô tả dynamic group."
  type        = string
  default     = null
}

variable "policy_name" {
  description = "Tên policy cấp quyền cho dynamic group (để trống sẽ tự sinh)."
  type        = string
  default     = null
}

variable "policy_description" {
  description = "Mô tả policy."
  type        = string
  default     = null
}

variable "policy_compartment_id" {
  description = "Compartment OCID cần cấp quyền (mặc định trùng domain_compartment_id)."
  type        = string
  default     = null
}

variable "tags" {
  description = "Freeform tags áp dụng cho tài nguyên IAM."
  type        = map(string)
  default     = {}
}