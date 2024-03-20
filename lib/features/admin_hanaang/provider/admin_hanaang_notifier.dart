import 'dart:io';

import 'package:admin_hanaang/features/admin_hanaang/data/admin_hanaang_api.dart';
import 'package:admin_hanaang/features/admin_hanaang/provider/admin_hanaang_provider.dart';
import 'package:admin_hanaang/features/state.dart';
import 'package:admin_hanaang/models/admin_hanaang.dart';
import 'package:admin_hanaang/models/detail_admin_hanaang.dart';
import 'package:admin_hanaang/utils/helper/failure_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminHanaangNotifier
    extends StateNotifier<BaseState<List<AdminHanaang>>> {
  final AdminHanaangApi _adminHanaangApi;

  AdminHanaangNotifier(this._adminHanaangApi) : super(const BaseState());

  Future getAdminHanaang({String? roleId, bool? makeLoading}) async {
    if (roleId == 'all') {
      roleId = null;
    }
    if (makeLoading != null && makeLoading) {
      state = state.copyWith(isLoading: true);
    }
    final result = await _adminHanaangApi.getAdminHanaang(
        roleId: roleId, page: state.page);
    result.fold(
      (error) => state =
          state.copyWith(isLoading: false, error: error, isLoadingMore: false),
      (response) => state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        error: null,
        data: response['data'],
        page: response['current_page'],
        lastPage: response['last_page'],
      ),
    );
  }

  Future<void> searchByQuery(String query) async {
    state = state.copyWith(page: 1);
    final result =
        await _adminHanaangApi.searchAdminHanaang(query, page: state.page);
    result.fold(
      (error) => state = state.copyWith(error: error),
      (response) => state = state.copyWith(
        error: null,
        data: response['data'],
        page: response['current_page'],
        lastPage: response['last_page'],
      ),
    );
  }

  void loadDataMore(String roleId) {
    state = state.copyWith(page: state.page + 1);
    getAdminHanaang(roleId: roleId);
  }

  void refresh() {
    state = state.copyWith(page: 1, isLoadingMore: true);
    getAdminHanaang(makeLoading: true);
  }
}

class CreateAdminNotifier extends Notifier<States> {
  @override
  States build() => States.noState();

  Future<bool> createAdminHanang({
    required String roleId,
    File? image,
    required String name,
    required String email,
    required String phoneNumber,
    required String password,
    required String passwordConfirm,
  }) async {
    state = States.loading();
    try {
      final result = await ref.watch(adminHanaangProvider).createAdminHanang(
            roleId,
            image: image,
            name: name,
            email: email,
            phoneNumber: phoneNumber,
            password: password,
            passwordConfirm: passwordConfirm,
          );
      state = result.fold(
        (error) => States.error(error),
        (response) {
          ref
              .watch(adminHanaangNotifier.notifier)
              .getAdminHanaang(makeLoading: true, roleId: roleId);
          return States.noState();
        },
      );
      return result.isRight();
    } catch (e) {
      state = States.error(exceptionTomessage(e));
      return false;
    }
  }
}

class TotalAdminHanaangNotifier extends StateNotifier<States> {
  final AdminHanaangApi _adminHanaangApi;

  TotalAdminHanaangNotifier(this._adminHanaangApi) : super(States.noState());

  void getTotal() async {
    final result = await _adminHanaangApi.getAdminHanaang();
    try {
      state = result.fold(
        (error) => States.error(error),
        (response) => States.finished(null, total: response['total']),
      );
    } catch (e) {
      state = States.error(exceptionTomessage(e));
    }
  }
}

class DetailAdminHanaangNotifier
    extends StateNotifier<States<DetailAdminHanaang>> {
  final AdminHanaangApi _adminHanaangApi;

  DetailAdminHanaangNotifier(this._adminHanaangApi) : super(States.noState());

  void getDetailData(String adminHanaangId) async {
    state = States.loading();
    try {
      final result =
          await _adminHanaangApi.getDetailAdminHanaang(adminHanaangId);
      state = result.fold(
        (error) => States.error(error),
        (data) => States.finished(data),
      );
    } catch (e) {
      state = States.error(exceptionTomessage(e));
    }
  }
}
