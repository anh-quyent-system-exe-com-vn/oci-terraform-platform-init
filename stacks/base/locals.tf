# Các biến cục bộ (locals) dùng để chuẩn hoá tên, DNS label và thẻ gắn (tags) cho tài nguyên
locals {
  # name_prefix: tiền tố đặt tên tài nguyên theo chuẩn "<environment>-<project>"
  # - Giúp gom nhóm tài nguyên theo môi trường (dev/stg/prod) và dự án
  name_prefix = "${var.environment}-${var.project}"

  # vcn_dns_label: nhãn DNS cho VCN
  # - lower(): chuyển về chữ thường
  # - replace(..., "[^a-z0-9]", ""): loại bỏ ký tự không hợp lệ (chỉ cho phép a-z0-9)
  # - substr(..., 0, 15): cắt tối đa 15 ký tự (giới hạn DNS label của OCI)
  vcn_dns_label = substr(replace(lower(var.project), "[^a-z0-9]", ""), 0, 15)

  # subnet_dns_label: nhãn DNS cho Subnet, thêm hậu tố "pub" để phân biệt subnet public
  # - Quy tắc xử lý tương tự vcn_dns_label (viết thường, bỏ ký tự lạ, tối đa 15 ký tự)
  subnet_dns_label = substr(replace(lower("${var.project}pub"), "[^a-z0-9]", ""), 0, 15)

  # tags: thẻ gắn để phân loại và truy vết tài nguyên
  # - Project: tên dự án
  # - Env: tên môi trường (dev/stg/prod/...)
  # - ManagedBy: đánh dấu do terraform quản lý để tiện vận hành
  tags = {
    # Tên dự án để gom nhóm chi phí/hiển thị
    Project   = var.project
    # Môi trường triển khai để áp chính sách/quy chuẩn phù hợp
    Env       = var.environment
    # Cờ đánh dấu nhằm nhận diện tài nguyên sinh bởi Terraform
    ManagedBy = "terraform"
  }
}