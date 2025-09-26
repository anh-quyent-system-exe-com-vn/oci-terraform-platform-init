terraform {
  required_version = "~> 1.5"

  required_providers {
    # Chính provider OCI dùng cho cấu hình bình thường
    oci = {
      source       = "oracle/oci"
      version      = ">= 5.40.0"
      region       = "${var.region}"
      tenancy_ocid = "${var.tenancy_ocid}"
      user_ocid    = "${var.user_ocid}"
    }

    # Thêm cấu hình provider tương thích để tránh ORM tự kéo "hashicorp/oci" mà không có cấu hình
    # Việc này đảm bảo nếu ORM/plug-in nào đó tham chiếu tới địa chỉ hashicorp/oci,
    # Terraform vẫn có một cấu hình mặc định (có region) cho địa chỉ đó.
    oci_compat = {
      source  = "hashicorp/oci"
      version = ">= 5.40.0"
    }
  }
}
