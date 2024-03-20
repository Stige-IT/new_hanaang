import 'dart:convert';
import 'dart:developer';

import 'package:admin_hanaang/features/http/http_provider.dart';
import 'package:admin_hanaang/features/storage/provider/storage_provider.dart';
import 'package:admin_hanaang/features/storage/service/storage_service.dart';
import 'package:admin_hanaang/models/bank_account.dart';
import 'package:admin_hanaang/models/bank_history.dart';
import 'package:admin_hanaang/models/history_income.dart';
import 'package:admin_hanaang/models/history_outcome.dart';
import 'package:admin_hanaang/utils/helper/formatted_role.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';

import '../../../utils/constant/base_url.dart';

final bankAccountProvider = Provider<BankAccountApi>((ref) {
  return BankAccountApi(ref.watch(httpProvider), ref.watch(storageProvider));
});

class BankAccountApi {
  final IOClient http;
  final SecureStorage storage;

  BankAccountApi(this.http, this.storage);

  Future<Either<String, List<BankAccount>>> getBankAccount() async {
    Uri url = Uri.parse("$BASEURL/super-admin/bank-account");
    final token = await storage.read("token");

    Map<String, String> header = {"Authorization": "Bearer $token"};

    Response response = await http.get(url, headers: header);

    if (response.statusCode == 200) {
      final List result = jsonDecode(response.body)['data'];
      final List<BankAccount> bankAccounts =
          result.map((account) => BankAccount.fromJson(account)).toList();
      return Right(bankAccounts);
    }
    return const Left("Gagal Get data Bank Accounts");
  }

  Future<Either<String, BankAccount>> getBankAccountById(
      String bankAccountId) async {
    Uri url =
        Uri.parse("$BASEURL/super-admin/bank-account/show/$bankAccountId");
    final token = await storage.read("token");

    Map<String, String> header = {"Authorization": "Bearer $token"};

    Response response = await http.get(url, headers: header);

    if (response.statusCode == 200) {
      final BankAccount bankAccounts =
          BankAccount.fromJson(jsonDecode(response.body)['data']);
      return Right(bankAccounts);
    }
    return const Left("Gagal Get data Bank Accounts");
  }

  Future<Either<String, int>> getSaldo() async {
    Uri url = Uri.parse("$BASEURL/super-admin/bank-account/total-saldo");
    final token = await storage.read("token");

    Map<String, String> header = {"Authorization": "Bearer $token"};
    Response response = await http.get(url, headers: header);

    if (response.statusCode == 200) {
      int saldo = jsonDecode(response.body)['data'] as int;
      return Right(saldo);
    }
    return const Left("Gagal memuat saldo");
  }

  Future<Either<String, String>> createBankAccount(
    String bankName,
    String accountName,
    String accountNumber,
    String ballance,
  ) async {
    Uri url = Uri.parse("$BASEURL/super-admin/bank-account/create");
    final token = await storage.read("token");
    Map data = {
      "bank_name": bankName,
      "account_name": accountName,
      "account_number": accountNumber,
      "ballance": ballance,
    };
    Map<String, String> header = {"Authorization": "Bearer $token"};

    Response response = await http.post(url, body: data, headers: header);

    if (response.statusCode == 200) {
      return const Right("Berhasil menambahkan akun bank");
    }
    return const Left("Gagal Get data Bank Accounts");
  }

  Future<Either<String, bool>> updateBankId(BankAccount account) async {
    Uri url =
        Uri.parse("$BASEURL/super-admin/bank-account/update/${account.id}");
    final token = await storage.read("token");
    Map data = {
      "bank_name": account.bankName,
      "account_name": account.accountName,
      "account_number": account.accountNumber,
    };
    Map<String, String> header = {"Authorization": "Bearer $token"};

    Response response = await http.post(url, body: data, headers: header);
    print(response.body);
    if (response.statusCode == 200) {
      return const Right(true);
    }
    return const Left("Gagal memperbaharui data bank");
  }

  Future<Either<String, bool>> updateBankToPrimary(String bankAccountId) async {
    Uri url = Uri.parse(
        "$BASEURL/super-admin/bank-account/update-to-primary/$bankAccountId");
    log(url.toString());
    final token = await storage.read("token");
    Map<String, String> header = {"Authorization": "Bearer $token"};

    Response response = await http.post(url, headers: header);
    print(response.body);
    if (response.statusCode == 200) {
      return const Right(true);
    }
    return const Left("Gagal memperbaharui status bank ke primary");
  }

  Future<Either<String, bool>> addSaldo(
    String bankAccountId, {
    required int nominal,
  }) async {
    Uri url = Uri.parse(
        "$BASEURL/super-admin/bank-account/update/saldo/$bankAccountId");
    final token = await storage.read("token");
    Map data = {"ballance": nominal.toString()};
    Map<String, String> header = {"Authorization": "Bearer $token"};

    Response response = await http.post(url, body: data, headers: header);

    if (response.statusCode == 200) {
      return const Right(true);
    }
    return const Left("Gagal menambah saldo");
  }

  Future<Either<String, bool>> transferSaldo(
      String senderBankId, String receiverBankId,
      {required int nominal}) async {
    Uri url = Uri.parse("$BASEURL/super-admin/bank-account/transfer");
    final token = await storage.read("token");
    Map data = {
      "id_bank_sender": senderBankId,
      "id_bank_reciver": receiverBankId,
      "nominal": nominal.toString(),
    };
    Map<String, String> header = {"Authorization": "Bearer $token"};

    Response response = await http.post(url, body: data, headers: header);

    if (response.statusCode == 200) {
      return const Right(true);
    }
    return const Left("Gagal mengirim saldo");
  }

  Future<Either<String, Map>> getBankHistory(
      {String? categoryName = "", String? bankAccountId = ""}) async {
    final typeAdmin = formattedPath(await storage.read('type_admin'));
    final token = await storage.read('token');
    Uri url = Uri.parse(
        "$BASEURL/$typeAdmin/finance/?categoryName=$categoryName&bankAccountId=$bankAccountId");

    Response response =
        await http.get(url, headers: {"Authorization": "Bearer $token"});
    if (response.statusCode == 200) {
      List result = jsonDecode(response.body)['data'];
      List<BankHistory> data =
          result.map((e) => BankHistory.fromJson(e)).toList();

      int currentPage = jsonDecode(response.body)['meta']['current_page'];
      int lastPage = jsonDecode(response.body)['meta']['last_page'];
      return Right({
        "data": data,
        "current_page": currentPage,
        "last_page": lastPage,
      });
    }

    return const Left("Gagal memuat history bank");
  }

  Future<Either<String, dynamic>> getDetailBankHistory(String bankHistoryId,
      {bool? isIncome = false}) async {
    final typeAdmin = formattedPath(await storage.read('type_admin'));
    final token = await storage.read('token');
    Uri url = Uri.parse("$BASEURL/$typeAdmin/finance/show/$bankHistoryId");

    Response response =
        await http.get(url, headers: {"Authorization": "Bearer $token"});
    log(response.body);
    if (response.statusCode == 200) {
      if (isIncome!) {
        Map<String, dynamic> result = jsonDecode(response.body)['data'];
        HistoryIncome data = HistoryIncome.fromJson(result);
        return Right(data);
      } else {
        Map<String, dynamic> result = jsonDecode(response.body)['data'];
        HistoryOutcome data = HistoryOutcome.fromJson(result);
        return Right(data);
      }
    }
    return const Left("Gagal memuat detail history bank");
  }

  Future<bool> removeBankAccount(BankAccount bankAccount) async {
    Uri url =
        Uri.parse("$BASEURL/super-admin/bank-account/delete/${bankAccount.id}");
    String token = await storage.read('token');
    Map<String, String> header = {"Authorization": "Bearer $token"};

    Response response = await http.delete(url, headers: header);
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }
}
