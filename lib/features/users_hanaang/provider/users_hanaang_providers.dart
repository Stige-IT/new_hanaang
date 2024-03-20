import 'package:admin_hanaang/features/state.dart';
import 'package:admin_hanaang/features/users_hanaang/data/users_hanaang_api.dart';
import 'package:admin_hanaang/features/users_hanaang/provider/users_hanaang_notifier.dart';
import 'package:admin_hanaang/features/users_hanaang/provider/users_hanaang_state.dart';
import 'package:admin_hanaang/models/user_hanaang_detail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/users_hanaang.dart';

final roleNameUserProvider = StateProvider<String>((ref) => "");

final userNotifier =
    StateNotifierProvider<UserHanaangNotifier, UserState>((ref) {
  return UserHanaangNotifier(
      ref.watch(usersHanaangProvider), ref.watch(roleNameUserProvider));
});

final createUserNotifier =
    StateNotifierProvider<CreateUserNotifier, States>((ref) {
  return CreateUserNotifier(ref.watch(usersHanaangProvider), ref);
});

final totalUserNotifier =
    StateNotifierProvider<TotalUserNotifier, UserState>((ref) {
  return TotalUserNotifier(ref.watch(usersHanaangProvider));
});

final userAgenNotifier =
    StateNotifierProvider<UserAgenNotifier, UserHanaangState>((ref) {
  return UserAgenNotifier(ref.watch(usersHanaangProvider));
});

final userDistributorNotifier =
    StateNotifierProvider<UserDistributorNotifier, UserHanaangState>((ref) {
  return UserDistributorNotifier(ref.watch(usersHanaangProvider));
});

final userFamilyNotifier =
    StateNotifierProvider<UserFamilyNotifier, UserHanaangState>((ref) {
  return UserFamilyNotifier(ref.watch(usersHanaangProvider));
});

final userWargaNotifier =
    StateNotifierProvider<UserWargaNotifier, UserHanaangState>((ref) {
  return UserWargaNotifier(ref.watch(usersHanaangProvider));
});

final newUserNotifier =
    StateNotifierProvider<NewUserNotifier, UserHanaangState>((ref) {
  return NewUserNotifier(ref.watch(usersHanaangProvider));
});

final userDetailNotifier = StateNotifierProvider<UserDetailNotifier,
    UserHanaangState<UserHanaangDetail>>((ref) {
  return UserDetailNotifier(ref.watch(usersHanaangProvider));
});

final allUsersHanaangNotifier = StateProvider<List<UsersHanaang>>((ref) {
  final agen = ref.watch(userAgenNotifier).data ?? [];
  final distributor = ref.watch(userDistributorNotifier).data ?? [];
  final family = ref.watch(userFamilyNotifier).data ?? [];
  final warga = ref.watch(userWargaNotifier).data ?? [];
  final newUser = ref.watch(newUserNotifier).data ?? [];

  List<UsersHanaang> allUsers = [
    ...agen,
    ...distributor,
    ...family,
    ...warga,
    ...newUser
  ];
  return allUsers;
});

final totalUserHanaangNotifier = StateProvider<int>((ref) {
  int agen = ref.watch(userAgenNotifier).data?.length ?? 0;
  int distributor = ref.watch(userDistributorNotifier).data?.length ?? 0;
  int family = ref.watch(userFamilyNotifier).data?.length ?? 0;
  int warga = ref.watch(userWargaNotifier).data?.length ?? 0;
  int newUser = ref.watch(newUserNotifier).data?.length ?? 0;

  int total = agen + distributor + family + warga + newUser;
  return total;
});
