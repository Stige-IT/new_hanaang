import 'dart:developer';

import 'package:admin_hanaang/config/constant/role_id.dart';
import 'package:admin_hanaang/config/router/router_config.dart';

import 'check_device_type.dart';

String navigationFirstRole(String roleId) {
  bool isTablet = isTabletType();
  Map<String, String> navigationRoutes = {
    RoleAdmin.superAdmin.value: "${AppRoutes.sa}/main",
    RoleAdmin.adminOrder.value: "${AppRoutes.admin}/shift",
    RoleAdmin.adminGudang.value: AppRoutes.admin,
    RoleAdmin.adminGudang2.value: AppRoutes.admin,
    RoleAdmin.adminGudang3.value: AppRoutes.admin,
  };

  log(roleId);
  if (navigationRoutes.containsKey(roleId)) {
    if (isTablet && roleId == RoleAdmin.superAdmin.value) {
      return "/not-support";
    } else {
      return navigationRoutes[roleId]!;
    }
  } else {
    return "/login";
  }
}
