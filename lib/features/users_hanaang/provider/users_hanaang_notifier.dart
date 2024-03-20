import 'dart:io';

import 'package:admin_hanaang/features/state.dart';
import 'package:admin_hanaang/features/users_hanaang/data/users_hanaang_api.dart';
import 'package:admin_hanaang/features/users_hanaang/provider/users_hanaang_providers.dart';
import 'package:admin_hanaang/models/user_hanaang_detail.dart';
import 'package:admin_hanaang/models/users_hanaang.dart';
import 'package:admin_hanaang/utils/helper/failure_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'users_hanaang_state.dart';

class UserHanaangNotifier extends StateNotifier<UserState> {
  final UsersHanaangApi _hanaangApi;
  final String nameRole;

  UserHanaangNotifier(this._hanaangApi, this.nameRole)
      : super(const UserState());

  getData({String? role, int? initPage, bool? makeLoading}) async {
    if (makeLoading != null && makeLoading) {
      state = state.copyWith(isLoading: true);
    }
    final page = initPage ?? 1;
    final result =
        await _hanaangApi.getUsersHanaang(role ?? nameRole, page: page);
    result.fold(
      (error) => state = state.copyWith(page: page, isLoading: false),
      (response) => state = state.copyWith(
        data: response["data"],
        isLoading: false,
        page: page,
        totalPage: response["last_page"],
      ),
    );
  }

  loadMoreData() async {
    state = state.copyWith(isLoadingMore: true);
    final result =
        await _hanaangApi.getUsersHanaang(nameRole, page: state.page + 1);

    result.fold(
      (error) => state = state.copyWith(isLoadMoreError: true),
      (response) => state = state.copyWith(
        page: state.page + 1,
        data: [...state.data!, ...response['data']],
        isLoadingMore: false,
      ),
    );
  }

  Future<List<UsersHanaang>> searchData(query) async {
    final result = await _hanaangApi.searchUsersHanaang(query);
    try {
      return result.fold(
        (error) => [],
        (data) {
          state = state.copyWith(data: data);
          return data;
        },
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> refresh({bool? makeLoading}) async {
    getData(initPage: 1, makeLoading: makeLoading);
  }
}

class CreateUserNotifier extends StateNotifier<States> {
  final UsersHanaangApi _usersHanaangApi;
  final Ref ref;
  CreateUserNotifier(this._usersHanaangApi, this.ref) : super(States.noState());

  Future<bool> create(
    String roleId, {
    required String name,
    required String email,
    required String phoneNumber,
    required String password,
    required String passwordConfirmation,
  }) async {
    state = States.loading();
    try {
      final result = await _usersHanaangApi.createNewUserHanaang(
        roleId,
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      return result.fold(
        (error) {
          state = States.error(error);
          return false;
        },
        (success) {
          ref.read(newUserNotifier.notifier).getUsersHanaang();
          state = States.noState();
          return true;
        },
      );
    } catch (exception) {
      state = States.error(exceptionTomessage(exception));
      return false;
    }
  }
}

class TotalUserNotifier extends StateNotifier<UserState> {
  final UsersHanaangApi _hanaangApi;

  TotalUserNotifier(this._hanaangApi) : super(const UserState());

  getTotal() async {
    final totalDistributor = await _hanaangApi.getUsersHanaang('Distributor');
    totalDistributor.fold((l) => null,
        (result) => state = state.copyWith(totalDistributor: result['total']));
    final totalAgen = await _hanaangApi.getUsersHanaang('Agen');
    totalAgen.fold((l) => null,
        (result) => state = state.copyWith(totalAgen: result['total']));
    final totalKeluarga = await _hanaangApi.getUsersHanaang('Keluarga');
    totalKeluarga.fold((l) => null,
        (result) => state = state.copyWith(totalKeluarga: result['total']));
    final totalWarga = await _hanaangApi.getUsersHanaang('Warga');
    totalWarga.fold((l) => null,
        (result) => state = state.copyWith(totalWarga: result['total']));
    final totalPengguna = await _hanaangApi.getUsersHanaang('User');
    totalPengguna.fold((l) => null,
        (result) => state = state.copyWith(totalPengguna: result['total']));
  }
}

class UserAgenNotifier extends StateNotifier<UserHanaangState> {
  final UsersHanaangApi userHanaangApi;

  UserAgenNotifier(this.userHanaangApi) : super(UserHanaangState.noState());

  Future getUsersHanaang() async {
    state = UserHanaangState.loading();
    try {
      final result = await userHanaangApi.getUserHanaang("Agen");
      result.fold(
        (error) => state = UserHanaangState.error(error),
        (data) => state = UserHanaangState.finished(data),
      );
    } on SocketException {
      state = UserHanaangState.error("Tidak ada koneksi Internet");
    } catch (e) {
      state = UserHanaangState.error(e.toString());
    }
  }
}

class UserDistributorNotifier extends StateNotifier<UserHanaangState> {
  final UsersHanaangApi userHanaangApi;

  UserDistributorNotifier(this.userHanaangApi)
      : super(UserHanaangState.noState());

  Future getUsersHanaang() async {
    state = UserHanaangState.loading();
    try {
      final result = await userHanaangApi.getUserHanaang("Distributor");
      result.fold(
        (error) => state = UserHanaangState.error(error),
        (data) => state = UserHanaangState.finished(data),
      );
    } on SocketException {
      state = UserHanaangState.error("Tidak ada koneksi Internet");
    } catch (e) {
      state = UserHanaangState.error(e.toString());
    }
  }
}

class UserFamilyNotifier extends StateNotifier<UserHanaangState> {
  final UsersHanaangApi userHanaangApi;

  UserFamilyNotifier(this.userHanaangApi) : super(UserHanaangState.noState());

  Future getUsersHanaang() async {
    state = UserHanaangState.loading();
    try {
      final result = await userHanaangApi.getUserHanaang("Keluarga");
      result.fold(
        (error) => state = UserHanaangState.error(error),
        (data) => state = UserHanaangState.finished(data),
      );
    } on SocketException {
      state = UserHanaangState.error("Tidak ada koneksi Internet");
    } catch (e) {
      state = UserHanaangState.error(e.toString());
    }
  }
}

class UserWargaNotifier extends StateNotifier<UserHanaangState> {
  final UsersHanaangApi userHanaangApi;

  UserWargaNotifier(this.userHanaangApi) : super(UserHanaangState.noState());

  Future getUsersHanaang() async {
    state = UserHanaangState.loading();
    try {
      final result = await userHanaangApi.getUserHanaang("Warga");
      result.fold(
        (error) => state = UserHanaangState.error(error),
        (data) => state = UserHanaangState.finished(data),
      );
    } on SocketException {
      state = UserHanaangState.error("Tidak ada koneksi Internet");
    } catch (e) {
      state = UserHanaangState.error(e.toString());
    }
  }
}

class NewUserNotifier extends StateNotifier<UserHanaangState> {
  final UsersHanaangApi userHanaangApi;

  NewUserNotifier(this.userHanaangApi) : super(UserHanaangState.noState());

  Future getUsersHanaang() async {
    state = UserHanaangState.loading();
    try {
      final result = await userHanaangApi.getUserHanaang("User");
      result.fold(
        (error) => state = UserHanaangState.error(error),
        (data) => state = UserHanaangState.finished(data),
      );
    } on SocketException {
      state = UserHanaangState.error("Tidak ada koneksi Internet");
    } catch (e) {
      state = UserHanaangState.error(e.toString());
    }
  }
}

class UserDetailNotifier
    extends StateNotifier<UserHanaangState<UserHanaangDetail>> {
  final UsersHanaangApi userHanaangApi;

  UserDetailNotifier(this.userHanaangApi) : super(UserHanaangState.noState());

  Future getUsersHanaang(String userId) async {
    state = UserHanaangState.loading();
    try {
      final result = await userHanaangApi.getDetailUserHanaang(userId);
      result.fold(
        (error) => state = UserHanaangState.error(error),
        (data) => state = UserHanaangState.finished(data),
      );
    } on SocketException {
      state = UserHanaangState.error("Tidak ada koneksi Internet");
    } catch (e) {
      state = UserHanaangState.error(e.toString());
    }
  }
}
