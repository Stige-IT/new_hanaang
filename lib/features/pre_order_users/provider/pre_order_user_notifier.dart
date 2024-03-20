import 'dart:io';

import 'package:admin_hanaang/features/pre_order_users/data/pre_order_user_api.dart';
import 'package:admin_hanaang/features/pre_order_users/provider/pre_order_user_provider.dart';
import 'package:admin_hanaang/models/pre_order_user.dart';
import 'package:admin_hanaang/utils/helper/failure_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state.dart';
import '../../stock/provider/stock_provider.dart';

class PreOrderUsersNotifier extends StateNotifier<States<List<PreOrderUser>>> {
  PreOrderUsersNotifier(this.api) : super(States.noState());

  final PreOrderUsersApi api;

  Future getPreOrderUsers({bool? makeLoading}) async {
    if (makeLoading != null && makeLoading) {
      state = States.loading();
    }
    try {
      final result = await api.getPreOrderUsers();
      result.fold(
        (error) => state = States.error(error),
        (response) => state = States.finished(response.data),
      );
    } catch (error) {
      state = States.error(exceptionTomessage(error));
    }
  }

  Future<void> search(String query) async {
    state = States.loading();
    try {
      final result = await api.searchPreOrder(query);
      result.fold(
        (error) => state = States.error(error),
        (data) => state = States.finished(data),
      );
    } catch (error) {
      state = States.error(exceptionTomessage(error));
    }
  }
}

class TotalPreOrderNotifier extends StateNotifier<States<int>> {
  final PreOrderUsersApi api;

  TotalPreOrderNotifier(this.api) : super(States.noState());

  Future<void> getTotal() async {
    state = States.loading();
    try {
      final result = await api.getPreOrderUsers();
      result.fold(
        (error) => state = States.error(error),
        (response) => state = States.finished(response.total),
      );
    } catch (error) {
      state = States.error(exceptionTomessage(error));
    }
  }
}

class UpdatePreOrderUsersNotifier extends StateNotifier<States> {
  UpdatePreOrderUsersNotifier(this.api, this.ref) : super(States.noState());

  final PreOrderUsersApi api;
  final Ref ref;

  Future<bool> updateToOrder(
    String preOrderUserId,
    String userId, {
    String? paymentMethodId,
    int? nominal,
    File? proofOfPayment,
    int? orderTaken,
  }) async {
    state = States.loading();
    try {
      final result = await api.updatePreOrderUser(
        preOrderUserId,
        userId,
        paymentMethodId: paymentMethodId,
        nominal: nominal,
        proofOfPayment: proofOfPayment,
        orderTaken: orderTaken,
      );
      return result.fold(
        (error) {
          state = States.error(error);
          return false;
        },
        (data) {
          ref.read(preOrderUsersNotifierProvider.notifier).getPreOrderUsers();
          // ref.read(orderNotifier.notifier).getOrders();
          ref.read(stockNotifier.notifier).getStock();
          state = States.noState();
          return true;
        },
      );
    } catch (error) {
      state = States.error(exceptionTomessage(error));
      return false;
    }
  }
}

class ResetPreOrderNotifier extends StateNotifier<States> {
  final PreOrderUsersApi _preOrderUsersApi;
  final Ref ref;

  ResetPreOrderNotifier(this._preOrderUsersApi, this.ref)
      : super(States.noState());

  Future<void> reset() async {
    state = States.loading();
    try {
      final result = await _preOrderUsersApi.resetPreOrder();
      result.fold(
        (error) => state = States.error(error),
        (success) {
          ref.read(preOrderUsersNotifierProvider.notifier).getPreOrderUsers();
          state = States.finished(success);
        },
      );
    } catch (error) {
      state = States.error(exceptionTomessage(error));
    }
  }
}
