import 'dart:convert';
import 'dart:developer';

import 'package:admin_hanaang/features/state.dart';
import 'package:admin_hanaang/utils/helper/navigation_first_role.dart';
import 'package:admin_hanaang/utils/helper/failure_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../storage/service/storage_service.dart';
import '../data/auth_api.dart';

class AuthNotifier extends StateNotifier<States<String>> {
  final AuthApi authApi;
  final SecureStorage storage;
  AuthNotifier(this.authApi, this.storage) : super(States.noState());

  Future<bool> login(String email, String password) async {
    state = States.loading();
    try {
      final result = await authApi.login(email: email, password: password);
      return result.fold((error) {
        state = States.error(error);
        return false;
      }, (response) async {
        final data = jsonDecode(response);
        await storage.write("token", data['access_token']);
        await storage.write("role_name", data['role_name']);
        await storage.write("type_admin", data['role_name']);
        state = States.finished(navigationFirstRole(data['role_name']));
        return true;
      });
    } catch (exception) {
      state = States.error(exceptionTomessage(exception));
      return false;
    }
  }

  Future logout() async {
    try {
      final response = await authApi.logout();
      await storage.deleteAll();
      return response.fold((l) => false, (r) => true);
    } catch (e) {
      log(e.toString());
    }
  }
}
