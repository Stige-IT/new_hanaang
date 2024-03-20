import 'package:admin_hanaang/features/admin_hanaang/data/admin_hanaang_api.dart';
import 'package:admin_hanaang/features/admin_hanaang/provider/admin_hanaang_notifier.dart';
import 'package:admin_hanaang/features/state.dart';
import 'package:admin_hanaang/models/detail_admin_hanaang.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/admin_hanaang.dart';

final adminHanaangNotifier =
    StateNotifierProvider<AdminHanaangNotifier, BaseState<List<AdminHanaang>>>(
        (ref) {
  return AdminHanaangNotifier(ref.watch(adminHanaangProvider));
});
final totalAdminHanaangNotifier =
    StateNotifierProvider<TotalAdminHanaangNotifier, States>((ref) {
  return TotalAdminHanaangNotifier(ref.watch(adminHanaangProvider));
});

final detailAdminHanaangNotifier = StateNotifierProvider<
    DetailAdminHanaangNotifier, States<DetailAdminHanaang>>((ref) {
  return DetailAdminHanaangNotifier(ref.watch(adminHanaangProvider));
});

final createAdminnNotifier =
    NotifierProvider<CreateAdminNotifier, States>(CreateAdminNotifier.new);
