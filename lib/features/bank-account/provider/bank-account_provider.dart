import 'package:admin_hanaang/features/bank-account/data/bank-account_api.dart';
import 'package:admin_hanaang/features/bank-account/provider/bank-account_notifier.dart';
import 'package:admin_hanaang/features/bank-account/provider/bank-account_state.dart';
import 'package:admin_hanaang/features/state.dart';
import 'package:admin_hanaang/models/bank_history.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/bank_account.dart';

final bankAccountNotifierProvider =
    StateNotifierProvider<BankAccountNotifier, BankAccountState>((ref) {
  return BankAccountNotifier(ref.watch(bankAccountProvider));
});

final createBankAccountNotifier =
    StateNotifierProvider<CreateBankAccountNotifier, States>((ref) {
  return CreateBankAccountNotifier(ref.watch(bankAccountProvider), ref);
});

final updateBankAccountNotifier =
    StateNotifierProvider<UpdateBankAccountNotifier, States>((ref) {
  return UpdateBankAccountNotifier(ref.watch(bankAccountProvider), ref);
});

final updateBankToPrimaryNotifier =
    StateNotifierProvider<UpdateBankToPrimaryNotifier, States>((ref) {
  return UpdateBankToPrimaryNotifier(ref.watch(bankAccountProvider), ref);
});

final addSaldoBankAccountNotifier =
    StateNotifierProvider<AddSaldoBankAccountNotifier, States>((ref) {
  return AddSaldoBankAccountNotifier(ref.watch(bankAccountProvider), ref);
});

final transferBankAccountNotifier =
    StateNotifierProvider<TransferBankAccountNotifier, States>((ref) {
  return TransferBankAccountNotifier(ref.watch(bankAccountProvider), ref);
});

final bankPrimaryNotifier =
    StateNotifierProvider<BankAccountPrimaryNotifier, BankAccount?>((ref) {
  return BankAccountPrimaryNotifier(ref.watch(bankAccountProvider));
});

final bankSaldoNotifier = StateNotifierProvider<BankSaldoNotifier, int>((ref) {
  return BankSaldoNotifier(ref.watch(bankAccountProvider));
});

final bankHistoryNotifier =
    StateNotifierProvider<BankHistoryNotifier, BaseState<List<BankHistory>>>(
        (ref) {
  return BankHistoryNotifier(ref.watch(bankAccountProvider));
});

final bankHistoryIncomeNotifier =
    StateNotifierProvider<BankHistoryNotifier, BaseState<List<BankHistory>>>(
        (ref) {
  return BankHistoryNotifier(ref.watch(bankAccountProvider));
});

final bankHistoryOutcomeNotifier =
    StateNotifierProvider<BankHistoryNotifier, BaseState<List<BankHistory>>>(
        (ref) {
  return BankHistoryNotifier(ref.watch(bankAccountProvider));
});

final detailBankHistoryNotifier =
    StateNotifierProvider<DetailBankHistoryNotifier, States>((ref) {
  return DetailBankHistoryNotifier(ref.watch(bankAccountProvider));
});
