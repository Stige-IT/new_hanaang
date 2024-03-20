import 'package:admin_hanaang/models/bank_account.dart';

class BankAccountByIdState {
  final BankAccount? data;
  final String? error;
  final bool isLoading;

  BankAccountByIdState({this.data, required this.isLoading, this.error});

  factory BankAccountByIdState.finished(BankAccount account) {
    return BankAccountByIdState(data: account, isLoading: false);
  }

  factory BankAccountByIdState.noState() {
    return BankAccountByIdState(isLoading: false);
  }

  factory BankAccountByIdState.loading() {
    return BankAccountByIdState(isLoading: true);
  }
  factory BankAccountByIdState.error(String error) {
    return BankAccountByIdState(isLoading: false, error: error);
  }
}
