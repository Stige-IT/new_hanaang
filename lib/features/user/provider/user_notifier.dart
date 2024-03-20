import 'dart:io';

import 'package:admin_hanaang/features/storage/service/storage_service.dart';
import 'package:admin_hanaang/features/user/data/user_api.dart';
import 'package:admin_hanaang/features/user/provider/user_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserNotifier extends StateNotifier<UserState> {
  UserNotifier(this.userApi) : super(UserState.noState());

  final UserApi userApi;

  Future getProfile() async {
    state = UserState.loading();
    final result = await userApi.getProfile();
    final address = await userApi.getUserAddress();
    result.fold((l) {
      state = UserState.error(l);
    }, (data) {
      address.fold(
        (l) => state = UserState.finished(user: data),
        (address) => state = UserState.finished(user: data, address: address),
      );
    });
  }

  Future updatePhotoProfile({
    File? image,
  }) async {
    state = UserState.loading();
    final result = await userApi.updatePhotoProfile(
      image!,
    );
    if (result) {
      getProfile();
      return true;
    } else {
      state = UserState.error(result);
      return state.error;
    }
  }

  Future getUserAddress() async {}
}

class UpdateUserNotifier extends StateNotifier<UserState> {
  final UserApi _userApi;

  UpdateUserNotifier(this._userApi) : super(UserState.noState());

  Future updateProfile({
    String? name,
    String? email,
    String? phone,
  }) async {
    state = UserState.loading();
    try {
      final result =
          await _userApi.updateProfile(name: name, email: email, phone: phone);

      return result.fold(
        (error) {
          state = UserState.error(error);
          return false;
        },
        (status) {
          state = UserState.noState();
          return true;
        },
      );
    } catch (e) {
      state = UserState.error(e.toString());
      return false;
    }
  }
}

class RoleNotifier extends StateNotifier<String?> {
  final SecureStorage storage;
  RoleNotifier(this.storage) : super(null);

  Future<void> getRole()async{
    final result = await storage.read('type_admin');
    state = result;
    print(state);
  }
}