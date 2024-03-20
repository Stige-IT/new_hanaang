import 'dart:convert';

import 'package:admin_hanaang/features/cashback/models/buyer_cashback.dart';
import 'package:admin_hanaang/features/http/http_provider.dart';
import 'package:admin_hanaang/features/http/http_request_client.dart';
import 'package:admin_hanaang/features/storage/provider/storage_provider.dart';
import 'package:admin_hanaang/features/storage/service/storage_service.dart';
import 'package:admin_hanaang/models/response_data.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';

import '../../../models/cashback.dart';
import '../../../utils/constant/base_url.dart';

final cashbackProvider = Provider<CashbackApi>((ref) {
  return CashbackApi(
    ref.watch(httpRequestProvider),
    ref.watch(httpProvider),
    ref.watch(storageProvider),
  );
});

class CashbackApi {
  final HttpRequestClient _http;
  final IOClient http;
  final SecureStorage storage;

  CashbackApi(this._http, this.http, this.storage);

  Future<Either<String, List<Cashback>>> getCashback({String? title}) async {
    final role = await storage.getRoleName();
    Uri url = Uri.parse("$BASEURL/$role/cashback/show/$title");
    try {
      String? token = await storage.read('token');

      Map<String, String> headers = {"Authorization": "Bearer $token"};

      Response response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        List result = jsonDecode(response.body)['data'];
        List<Cashback> data = result.map((e) => Cashback.fromJson(e)).toList();
        return Right(data);
      } else {
        return const Right([]);
      }
    } catch (e) {
      return Left("Error $e");
    }
  }

  Future<Either<String, ResponseData<List<BuyerCashback>>>> getBuyerCashback(
      int page) async {
    final role = await storage.getRoleName();
    final url = "$BASEURL/$role/buyer-cashback?page=$page";
    final response = await _http.get(url);
    return response.fold(
      (error) => Left(error),
      (response) {
        final resultData = response['data'];
        final data = resultData.map((e) => BuyerCashback.fromJson(e)).toList();
        final result =
            ResponseData<List<BuyerCashback>>.fromJson(response, data);
        return Right(result);
      },
    );
  }

  Future<Either<String, int>> checkCashback(String userId, int quantity) async {
    final role = await storage.getRoleName();
    final url = Uri.parse("$BASEURL/$role/cashback/check");
    try {
      String? token = await storage.read('token');

      Map<String, String> headers = {"Authorization": "Bearer $token"};
      Map data = {'user_id': userId, "quantity": quantity.toString()};

      Response response = await http.post(url, body: data, headers: headers);

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body)['data'];
        int bonus = result is int ? result : int.parse(result);
        return Right(bonus);
      } else {
        return const Left("Tidak ada Bonus");
      }
    } catch (e) {
      return Left("Error $e");
    }
  }

  Future<Either<String, bool>> createCashback({
    required String cashbackType,
    required String minimumOrder,
    required String cashbackOfNumber,
  }) async {
    final role = await storage.getRoleName();
    Uri url = Uri.parse("$BASEURL/$role/cashback/create");
    String? token = await storage.read('token');
    Map<String, String> headers = {"Authorization": "Bearer $token"};
    Map data = {
      "cashback_type": cashbackType,
      "minimum_order": minimumOrder,
      "number_of_cashback": cashbackOfNumber,
    };
    Response response = await http.post(url, body: data, headers: headers);

    if (response.statusCode == 200) {
      return const Right(true);
    }
    return const Left("Gagal membuat data cashback");
  }

  Future<Either<String, bool>> updateCashbackById(
    String id, {
    required String cashbackType,
    required String minimumOrder,
    required String cashbackOfNumber,
  }) async {
    final role = await storage.getRoleName();
    Uri url = Uri.parse("$BASEURL/$role/cashback/update/$id");
    String? token = await storage.read('token');
    Map<String, String> headers = {"Authorization": "Bearer $token"};
    Map data = {
      "minimum_order": minimumOrder,
      "number_of_cashback": cashbackOfNumber,
    };
    Response response = await http.post(url, body: data, headers: headers);

    if (response.statusCode == 200) {
      return const Right(true);
    }
    return const Left("gagal memperbaharui data cashback");
  }

  Future<Either<String, bool>> deleteCashback(String id) async {
    final role = await storage.getRoleName();
    final url = Uri.parse("$BASEURL/$role/cashback/delete/$id");
    String? token = await storage.read('token');
    Map<String, String> headers = {"Authorization": "Bearer $token"};
    Response response = await http.delete(url, headers: headers);

    if (response.statusCode == 200) {
      return const Right(true);
    } else {
      return const Left("Gagal menghapus Cashback");
    }
  }
}
