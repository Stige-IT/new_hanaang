import 'package:admin_hanaang/features/manage_access_warehouse/data/manage_access_api.dart';
import 'package:admin_hanaang/features/manage_access_warehouse/provider/manage_acces_notifier.dart';
import 'package:admin_hanaang/features/state.dart';
import 'package:admin_hanaang/models/manage_access.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final manageAccessNotifier =
    StateNotifierProvider<ManageAccessNotifier, States<List<ManageAccess>>>(
        (ref) {
  return ManageAccessNotifier(ref.watch(manageAccessProvider));
});

final detailManageAccessNotifier =
    StateNotifierProvider<DetailManageAccessNotifier, States<ManageAccess>>(
        (ref) {
  return DetailManageAccessNotifier(ref.watch(manageAccessProvider));
});

final updateManageAccessNotifier =
    StateNotifierProvider<UpdateManageAccessNotifier, States>((ref) {
  return UpdateManageAccessNotifier(ref.watch(manageAccessProvider), ref);
});
