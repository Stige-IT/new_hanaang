import 'package:admin_hanaang/features/payment/data/payment_api.dart';
import 'package:admin_hanaang/features/payment/provider/payment_notifier.dart';
import 'package:admin_hanaang/features/payment/provider/payment_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state.dart';

final paymentNotifier =
    StateNotifierProvider<PaymentNotifier, PaymentState>((ref) {
  return PaymentNotifier(ref.watch(paymentProvider));
});

final createPaymentNotifier =
    StateNotifierProvider<CreatePaymentNotifier, States>((ref) {
  return CreatePaymentNotifier(ref.watch(paymentProvider), ref);
});
