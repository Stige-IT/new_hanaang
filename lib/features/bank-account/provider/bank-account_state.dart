import 'package:admin_hanaang/models/bank_account.dart';

class BankAccountState {
  final List<BankAccount>? data;
  final String? error;
  final bool isLoading;

  BankAccountState({this.data, required this.isLoading, this.error});

  factory BankAccountState.finished(List<BankAccount> user) {
    return BankAccountState(data: user, isLoading: false);
  }

  factory BankAccountState.noState() {
    return BankAccountState(isLoading: false);
  }

  factory BankAccountState.loading() {
    return BankAccountState(isLoading: true);
  }
  factory BankAccountState.error(String error) {
    return BankAccountState(isLoading: true, error: error);
  }
}
