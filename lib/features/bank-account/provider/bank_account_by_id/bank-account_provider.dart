import 'package:admin_hanaang/features/bank-account/data/bank-account_api.dart';
import 'package:admin_hanaang/features/bank-account/provider/bank_account_by_id/bank-account_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'bank-account_notifier.dart';

final bankAccountByIdProvider =
    StateNotifierProvider<BankAccountByIdNotifier, BankAccountByIdState>((ref) {
  return BankAccountByIdNotifier(ref.watch(bankAccountProvider));
});
