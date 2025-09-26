# Các biến cục bộ (locals) cho module IAM
# Mục tiêu: Chuẩn hoá tên/diễn giải Domain, Dynamic Group và sinh policy cho phép DG quản trị tài nguyên
locals {
  # domain_display_name: Tên hiển thị cho Identity Domain
  # - Nếu không truyền vào, tự tạo theo mẫu "<name_prefix>-domain"
  domain_display_name = coalesce(var.domain_display_name, format("%s-domain", var.name_prefix))

  # domain_description: Mô tả cho Identity Domain
  # - Nếu không truyền vào, tạo mô tả gắn với môi trường từ name_prefix
  domain_description = coalesce(
    var.domain_description,
    format("Identity domain for %s environment", var.name_prefix)
  )

  # dynamic_group_name: Tên của Dynamic Group
  # - Mặc định sinh theo mẫu "<name_prefix>-dg" nếu không cung cấp
  dynamic_group_name = coalesce(var.dynamic_group_name, format("%s-dg", var.name_prefix))

  # generated_matching_rule: Tự động sinh matching_rule cho Dynamic Group khi có danh sách instance_ids
  # - Cú pháp: ANY { instance.id = '<ocid1.instance...>', instance.id = '<ocid1.instance...>', ... }
  # - Khi instance_ids rỗng: trả về null để có thể dùng custom_matching_rule (nếu được cung cấp)
  generated_matching_rule = length(var.instance_ids) > 0 ? format(
    "ANY {%s}",
    join(", ", [for id in var.instance_ids : format("instance.id = '%s'", id)])
  ) : null

  # dynamic_group_matching_rule: Luật match cuối cùng dùng cho Dynamic Group
  # - Ưu tiên var.custom_matching_rule nếu được khai báo
  # - Nếu không có, fallback sang generated_matching_rule ở trên
  dynamic_group_matching_rule = coalesce(var.custom_matching_rule, local.generated_matching_rule)

  # policy_name: Tên của Policy cấp quyền cho Dynamic Group
  # - Mặc định sinh theo mẫu "<name_prefix>-dg-policy"
  policy_name = coalesce(var.policy_name, format("%s-dg-policy", var.name_prefix))

  # policy_compartment_id: OCID compartment nơi policy áp dụng (DG sẽ có quyền tại compartment này)
  # - Mặc định: var.domain_compartment_id
  # - Có thể override từ stack: đặt bằng OCID của environment compartment để DG có quyền trong đúng môi trường
  policy_compartment_id = coalesce(var.policy_compartment_id, var.domain_compartment_id)

  # policy_description: Mô tả cho Policy
  # - Mặc định diễn giải rõ rằng DG được quyền manage all resources trong compartment id tương ứng
  policy_description = coalesce(
    var.policy_description,
    format(
      "Allow dynamic group %s to manage all resources in compartment id %s",
      local.dynamic_group_name,
      local.policy_compartment_id
    )
  )

  # policy_statements: Danh sách câu lệnh IAM Policy
  # - Câu lệnh dưới đây cho phép DG "manage all-resources" trong compartment chỉ định
  # - Đây chính là chỗ thực thi yêu cầu: DG có thể tạo/quản trị tài nguyên trong compartment môi trường
  policy_statements = [
    format(
      "Allow dynamic-group %s to manage all-resources in compartment id %s",
      local.dynamic_group_name,
      local.policy_compartment_id
    )
  ]
}
