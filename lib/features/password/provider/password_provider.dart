import 'package:admin_hanaang/features/password/data/password_api.dart';
import 'package:admin_hanaang/features/password/provider/password_notifer.dart';
import 'package:admin_hanaang/features/password/provider/password_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final passwordnotifierProvider =
    StateNotifierProvider<PasswordNotifer, PasswordState>((ref) {
  return PasswordNotifer(ref.watch(passwordProvider));
});
