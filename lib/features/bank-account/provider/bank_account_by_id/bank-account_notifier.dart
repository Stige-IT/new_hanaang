import 'dart:io';

import 'package:admin_hanaang/features/bank-account/data/bank-account_api.dart';
import 'package:admin_hanaang/features/bank-account/provider/bank_account_by_id/bank-account_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BankAccountByIdNotifier extends StateNotifier<BankAccountByIdState> {
  BankAccountByIdNotifier(this.bankAccountApi)
      : super(BankAccountByIdState.noState());

  final BankAccountApi bankAccountApi;

  Future getBankAccountsById(String bankAccountId, {bool? makeLoading}) async {
    if (makeLoading != null && makeLoading) {
      state = BankAccountByIdState.loading();
    }
    try {
      final result = await bankAccountApi.getBankAccountById(bankAccountId);
      result.fold(
        (l) => state = BankAccountByIdState.error(l),
        (r) => state = BankAccountByIdState.finished(r),
      );
    } on SocketException {
      state = BankAccountByIdState.error("Tidak ada Internet");
    }
  }
}
