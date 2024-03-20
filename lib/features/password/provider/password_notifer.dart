import 'package:admin_hanaang/features/password/data/password_api.dart';
import 'package:admin_hanaang/features/password/provider/password_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PasswordNotifer extends StateNotifier<PasswordState> {
  PasswordNotifer(this.passwordApi) : super(PasswordState.noState());

  final PasswordApi passwordApi;

  Future updatePassword({
    String? oldPassword,
    String? newPassword,
    String? confirmPassword,
  }) async {
    state = PasswordState.loading();

    final result = await passwordApi.updatePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
    bool status = false;
    result.fold((l) {
      state = PasswordState.error(l);
    }, (r) {
      state = PasswordState.noState();
      status = true;
    });
    return status;
  }
}
