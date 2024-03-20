import 'dart:io';

import 'package:admin_hanaang/features/payment/data/payment_api.dart';
import 'package:admin_hanaang/features/payment/provider/payment_provider.dart';
import 'package:admin_hanaang/features/payment/provider/payment_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../order/order.dart';
import '../../state.dart';


class PaymentNotifier extends StateNotifier<PaymentState> {
  PaymentNotifier(this.api) : super(PaymentState.noState());

  final PaymentApi api;

  Future getPayment(String id, {bool? makeLoading}) async {
    if (makeLoading != null && makeLoading) {
      state = PaymentState.loading();
    }
    final result = await api.getPayment(id);
    result.fold(
      (l) => state = PaymentState.error(l),
      (r) => state = PaymentState.finished(r),
    );
  }
}

class CreatePaymentNotifier extends StateNotifier<States> {
  final PaymentApi _paymentApi;
  final Ref ref;
  CreatePaymentNotifier(this._paymentApi, this.ref) : super(States.noState());

  Future<bool> createNewPayment(
    String orderId,
    String id, {
    required String paymentMethodId,
    required String nominal,
    File? image,
  }) async {
    state = States.loading();
    try {
      final result = await _paymentApi.createNewPayment(
        id,
        paymentMethodId: paymentMethodId,
        nominal: nominal,
        image: image,
      );
      return result.fold(
        (error) {
          state = States.error(error);
          return false;
        },
        (success) {
          ref.read(orderNotifier.notifier).getOrders();
          ref.read(paymentNotifier.notifier).getPayment(id);
          ref.read(orderByIdNotifier.notifier).getOrdersById(orderId);
          state = States.noState();
          return true;
        },
      );
    } on SocketException {
      state = States.error("Tidak ada internet");
      return false;
    }
  }
}
