import 'package:admin_hanaang/config/constant/role_id.dart';

String formattedPath(String roleId) {
  switch (roleId) {
    case "25fc4476-eca7-44d8-8b40-2b1a21e9b4a0":
      return "super-admin";
    case "6ddd7c18-90e6-46c7-a105-489991970193":
      return "admin-order";
    case "b57e9747-f8ac-4d26-a39e-406f38c06eb0":
    case "be96d685-2322-11ee-8a79-5ea00b5791d2":
    case "c7df2fad-2322-11ee-8a79-5ea00b5791d2":
      return 'admin-gudang';
    default:
      return "error coba login kembali";
  }
}

Map data = {
  "Distributor": "4b736cf3-3d81-4c39-8e44-1a7ebf16422d",
  "Agen": "52bcee5d-57ea-4037-b7cd-a8e0b3f3555f",
  "Warga": "fbf8807d-0f97-4c1a-b42f-e14d7901f9c2",
  "Keluarga": "d627b4bb-7243-49e7-913e-78e8a983c9f5",
  "Pengguna": "c1ecf558-5e51-4f40-b657-e65b54985847",
};

String formatToRoleUser(String roleId) {
  return data.entries
      .firstWhere(
        (item) => item.value.toString().toLowerCase() == roleId.toLowerCase(),
      )
      .key;
}

Map dataAdmin = {
  "Admin Gudang 1": RoleAdmin.adminGudang.value,
  "Admin Gudang 2": RoleAdmin.adminGudang2.value,
  "Admin Gudang 3": RoleAdmin.adminGudang3.value,
  "Admin Order": RoleAdmin.adminOrder.value,
  "Super Admin": RoleAdmin.superAdmin.value,
};

String formatToRoleAdmin (String roleId) {
  return dataAdmin.entries
      .firstWhere(
        (item) => item.value.toString().toLowerCase() == roleId.toLowerCase(),
  )
      .key;
}


