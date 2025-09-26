terraform {
  required_version = "~> 1.5"
  required_providers {
    # Chính provider OCI dùng cho cấu hình bình thường
    oci = {
      source  = "oracle/oci"
      version = ">= 5.0"
    }
  }
}
