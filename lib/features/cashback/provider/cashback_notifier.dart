import 'dart:developer';
import 'dart:io';

import 'package:admin_hanaang/features/cashback/data/cashback_api.dart';
import 'package:admin_hanaang/features/cashback/provider/cashback_provider.dart';
import 'package:admin_hanaang/features/state.dart';
import 'package:admin_hanaang/utils/helper/failure_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/buyer_cashback.dart';

class CashbackNotifier extends StateNotifier<States> {
  CashbackNotifier(this.api) : super(States.noState());

  final CashbackApi api;

  Future getCashback({String? title, bool? makeLoading = false}) async {
    if (makeLoading!) {
      state = States.loading();
    }
    try {
      final result = await api.getCashback(title: title);
      result.fold(
        (error) => state = States.error(error),
        (data) => state = States.finished(data),
      );
    } catch (exception) {
      state = States.error(exceptionTomessage(exception));
    }
  }
}

class CashbackBuyerNotifier extends Notifier<BaseState<List<BuyerCashback>>> {
  @override
  BaseState<List<BuyerCashback>> build() => BaseState.noState();

  void get({bool? makeLoading = false, bool? isLoadMore = false}) async {
    if (makeLoading!) {
      state = BaseState.loading();
    }
    try {
      final result =
          await ref.watch(cashbackProvider).getBuyerCashback(state.page);
      state = result.fold(
        (error) => BaseState.error(error),
        (data) {
          return BaseState.finished(
            isLoadMore! ? [...state.data!, ...data.data!] : data.data!,
            total: data.total,
            page: data.currentPage,
            lastPage: data.lastPage,
          );
        },
      );
    } catch (e) {
      state = BaseState.error(exceptionTomessage(e));
    }
  }

  void loadMore() {
    state = state.copyWith(page: state.page + 1, isLoadingMore: true);
    get(isLoadMore: true);
  }

  void refresh() => get(makeLoading: true);
}

class CreateCashbackNotifier extends StateNotifier<States> {
  CreateCashbackNotifier(this.api, this.ref) : super(States.noState());

  final CashbackApi api;
  final Ref ref;

  Future<bool> createCashback({
    required String cashbackType,
    required String minimumOrder,
    required String cashbackOfNumber,
  }) async {
    state = States.loading();
    try {
      final result = await api.createCashback(
        cashbackType: cashbackType,
        minimumOrder: minimumOrder,
        cashbackOfNumber: cashbackOfNumber,
      );
      return result.fold(
        (error) {
          state = States.error(error);
          return false;
        },
        (status) {
          final typeCashback = ref.read(typeIdCashbackProvider);
          ref.read(cashbackNotifier.notifier).getCashback(title: typeCashback);
          state = States.noState();
          return status;
        },
      );
    } on SocketException {
      state = States.error("Tidak ada internet");
      return false;
    } catch (e) {
      state = States.error("Masalah pada sistem");
      return false;
    }
  }
}

class UpdateCashbackNotifier extends StateNotifier<States> {
  UpdateCashbackNotifier(this.api, this.ref) : super(States.noState());

  final CashbackApi api;
  final Ref ref;

  Future<bool> updateCashback(
    String id, {
    required String cashbackType,
    required String minimumOrder,
    required String cashbackOfNumber,
  }) async {
    state = States.loading();
    try {
      final result = await api.updateCashbackById(
        id,
        cashbackType: cashbackType,
        minimumOrder: minimumOrder,
        cashbackOfNumber: cashbackOfNumber,
      );

      return result.fold(
        (error) {
          state = States.error(error);
          return false;
        },
        (status) {
          final typeCashback = ref.read(typeIdCashbackProvider);
          ref.read(cashbackNotifier.notifier).getCashback(title: typeCashback);
          state = States.noState();
          return status;
        },
      );
    } on SocketException {
      state = States.error("Tidak ada internet");
      return false;
    } catch (e) {
      state = States.error("Masalah pada sistem");
      return false;
    }
  }
}

class DeleteCashbackNotifier extends StateNotifier<States> {
  DeleteCashbackNotifier(this.api, this.ref) : super(States.noState());

  final CashbackApi api;
  final Ref ref;

  Future<bool> delete(String id) async {
    state = States.loading();
    try {
      final result = await api.deleteCashback(id);
      return result.fold(
        (error) {
          state = States.error(error);
          return false;
        },
        (status) {
          final typeCashback = ref.read(typeIdCashbackProvider);
          ref.read(cashbackNotifier.notifier).getCashback(title: typeCashback);
          state = States.noState();
          return true;
        },
      );
    } on SocketException {
      state = States.error("Tidak ada internet");
      return false;
    } catch (e) {
      state = States.error("Masalah pada sistem");
      log(e.toString());
      return false;
    }
  }
}

class CheckCashbackNotifier extends StateNotifier<States<int>> {
  final CashbackApi api;

  CheckCashbackNotifier(this.api) : super(States.noState());

  Future checkCashback(String userId, int quantity) async {
    state = States.loading();
    try {
      final result = await api.checkCashback(userId, quantity);
      result.fold(
        (error) => state = States.error(error),
        (data) => state = States.finished(data),
      );
    } catch (exception) {
      state = States.error(exceptionTomessage(exception));
    }
  }
}
