import 'package:admin_hanaang/features/storage/provider/storage_provider.dart';
import 'package:admin_hanaang/features/user/data/user_api.dart';
import 'package:admin_hanaang/features/user/provider/user_notifier.dart';
import 'package:admin_hanaang/features/user/provider/user_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final userNotifierProvider =
    StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier(ref.watch(userProvider));
});

final updateUserNotifier =
    StateNotifierProvider<UpdateUserNotifier, UserState>((ref) {
  return UpdateUserNotifier(ref.watch(userProvider));
});


final roleNotifier = StateNotifierProvider<RoleNotifier,String?>((ref) {
  return RoleNotifier(ref.watch(storageProvider));
});

