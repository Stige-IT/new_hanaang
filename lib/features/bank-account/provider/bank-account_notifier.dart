import 'dart:io';

import 'package:admin_hanaang/features/bank-account/data/bank-account_api.dart';
import 'package:admin_hanaang/features/bank-account/provider/bank-account_provider.dart';
import 'package:admin_hanaang/features/bank-account/provider/bank-account_state.dart';
import 'package:admin_hanaang/features/bank-account/provider/bank_account_by_id/bank-account_provider.dart';
import 'package:admin_hanaang/features/state.dart';
import 'package:admin_hanaang/models/bank_account.dart';
import 'package:admin_hanaang/models/bank_history.dart';
import 'package:admin_hanaang/utils/helper/failure_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BankAccountNotifier extends StateNotifier<BankAccountState> {
  BankAccountNotifier(this.bankAccountApi) : super(BankAccountState.noState());

  final BankAccountApi bankAccountApi;

  Future getBankAccounts({bool? makeLoading}) async {
    if (makeLoading != null && makeLoading) {
      state = BankAccountState.loading();
    }
    try {
      final result = await bankAccountApi.getBankAccount();
      result.fold(
        (l) => state,
        (r) => state = BankAccountState.finished(r),
      );
    } catch (e) {
      state = BankAccountState.error("Error $e");
    }
  }
}

class CreateBankAccountNotifier extends StateNotifier<States> {
  final BankAccountApi _bankAccountApi;
  final Ref ref;

  CreateBankAccountNotifier(this._bankAccountApi, this.ref)
      : super(States.noState());

  Future<bool> createBankAccount({
    required String bankName,
    required String accountName,
    required String accountNumber,
    required String ballance,
  }) async {
    state = States.loading();
    try {
      final result = await _bankAccountApi.createBankAccount(
          bankName, accountName, accountNumber, ballance);
      state = result.fold(
        (error) => States.error(error),
        (success) {
          ref.read(bankAccountNotifierProvider.notifier).getBankAccounts();
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

class UpdateBankAccountNotifier extends StateNotifier<States> {
  final BankAccountApi _bankAccountApi;
  final Ref ref;

  UpdateBankAccountNotifier(this._bankAccountApi, this.ref)
      : super(States.noState());

  Future<bool> updateBankAccount(BankAccount account) async {
    state = States.loading();
    try {
      final result = await _bankAccountApi.updateBankId(account);
      state = result.fold(
        (error) => States.error(error),
        (success) {
          ref
              .read(bankAccountByIdProvider.notifier)
              .getBankAccountsById(account.id!);
          ref.read(bankAccountNotifierProvider.notifier).getBankAccounts();
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

class UpdateBankToPrimaryNotifier extends StateNotifier<States> {
  final BankAccountApi _bankAccountApi;
  final Ref ref;

  UpdateBankToPrimaryNotifier(this._bankAccountApi, this.ref)
      : super(States.noState());

  Future<bool> updateToPrimary(String bankAccountId) async {
    state = States.loading();
    try {
      final result = await _bankAccountApi.updateBankToPrimary(bankAccountId);
      return result.fold(
        (error) {
          state = States.error(error);
          return false;
        },
        (success) {
          ref
              .read(bankAccountByIdProvider.notifier)
              .getBankAccountsById(bankAccountId);
          ref.read(bankAccountNotifierProvider.notifier).getBankAccounts();
          state = States.noState();
          return true;
        },
      );
    } catch (exception) {
      state = States.error(exceptionTomessage(exception));
      return false;
    }
  }
}

class AddSaldoBankAccountNotifier extends StateNotifier<States> {
  final BankAccountApi _bankAccountApi;
  final Ref ref;

  AddSaldoBankAccountNotifier(this._bankAccountApi, this.ref)
      : super(States.noState());

  Future<bool> addSaldo(
    String bankAccountId, {
    required int nominal,
  }) async {
    state = States.loading();
    try {
      final result =
          await _bankAccountApi.addSaldo(bankAccountId, nominal: nominal);
      return result.fold(
        (error) {
          state = States.error(error);
          return false;
        },
        (success) {
          ref
              .read(bankHistoryNotifier.notifier)
              .getHistoy(bankAccountId: bankAccountId);
          ref
              .read(bankAccountByIdProvider.notifier)
              .getBankAccountsById(bankAccountId);
          ref.read(bankAccountNotifierProvider.notifier).getBankAccounts();
          state = States.noState();
          return true;
        },
      );
    } catch (exception) {
      state = States.error(exceptionTomessage(exception));
      return false;
    }
  }
}

class TransferBankAccountNotifier extends StateNotifier<States> {
  final BankAccountApi _bankAccountApi;
  final Ref ref;

  TransferBankAccountNotifier(this._bankAccountApi, this.ref)
      : super(States.noState());

  Future<bool> transferSaldo(String senderBankId, String receiverBankId,
      {required int nominal}) async {
    state = States.loading();
    try {
      final result = await _bankAccountApi
          .transferSaldo(senderBankId, receiverBankId, nominal: nominal);
      state =  result.fold(
        (error) => States.error(error),
        (success) {
          ref
              .read(bankAccountByIdProvider.notifier)
              .getBankAccountsById(senderBankId);
          ref.read(bankAccountNotifierProvider.notifier).getBankAccounts();
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

class BankAccountPrimaryNotifier extends StateNotifier<BankAccount?> {
  BankAccountPrimaryNotifier(this.bankAccountApi) : super(null);

  final BankAccountApi bankAccountApi;

  Future getBankAccountPrimary() async {
    try {
      final result = await bankAccountApi.getBankAccount();
      final data = result.fold(
        (l) => null,
        (r) => r,
      );

      for (BankAccount item in data!) {
        if (item.primary == '1') {
          state = item;
        }
      }
    } catch (e) {}
  }
}

class BankSaldoNotifier extends StateNotifier<int> {
  final BankAccountApi bankAccountApi;

  BankSaldoNotifier(this.bankAccountApi) : super(0);

  Future getBankSaldo() async {
    final result = await bankAccountApi.getSaldo();
    result.fold(
      (l) => null,
      (r) => state = r,
    );
  }
}

class BankHistoryNotifier extends StateNotifier<BaseState<List<BankHistory>>> {
  final BankAccountApi _bankAccountApi;

  BankHistoryNotifier(this._bankAccountApi) : super(const BaseState());

  getHistoy({String? categoryName, String? bankAccountId}) async {
    state = state.copyWith(isLoading: true);
    try {
      final result = await _bankAccountApi.getBankHistory(
          categoryName: categoryName, bankAccountId: bankAccountId);
      result.fold(
        (error) => state = state.copyWith(isLoading: false, error: error),
        (response) => state = state.copyWith(
          isLoading: false,
          error: null,
          data: response['data'],
          page: response['current_page'],
          lastPage: response['last_page'],
        ),
      );
    } on SocketException {
      state = state.copyWith(isLoading: false, error: "Tidak ada internet");
    } catch (e) {
      state = state.copyWith(isLoading: false, error: "Sistem dalam masalah");
      throw Exception(e);
    }
  }

  getDataMore({String? categoryName, String? bankAccountId}) async {
    state = state.copyWith(isLoadingMore: true);
    try {
      final result = await _bankAccountApi.getBankHistory(
          categoryName: categoryName, bankAccountId: bankAccountId);
      result.fold(
        (error) => state = state.copyWith(isLoadingMore: false, error: error),
        (response) => state = state.copyWith(
          isLoadingMore: false,
          error: null,
          data: [...response['data'], ...state.data!],
          page: response['current_page'],
          lastPage: response['last_page'],
        ),
      );
    } on SocketException {
      state = state.copyWith(isLoading: false, error: "Tidak ada internet");
    } catch (e) {
      state = state.copyWith(isLoading: false, error: "Sistem dalam masalah");
      throw Exception(e);
    }
  }

  void refresh({String? categoryName, String? bankAccountId}) {
    state = state.copyWith(page: 1);
    getHistoy(categoryName: categoryName, bankAccountId: bankAccountId);
  }
}

class DetailBankHistoryNotifier extends StateNotifier<States> {
  final BankAccountApi _bankAccountApi;

  DetailBankHistoryNotifier(this._bankAccountApi) : super(States.noState());

  void getDetailHistory(String bankHistoryId, {bool? isIncome}) async {
    state = States.loading();
    try {
      final result = await _bankAccountApi.getDetailBankHistory(bankHistoryId,
          isIncome: isIncome);
      state = result.fold(
        (error) => States.error(error),
        (data) => States.finished(data),
      );
    } catch (e) {
      state = States.error(exceptionTomessage(e));
    }
  }
}
