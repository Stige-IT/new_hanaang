import 'dart:convert';

import 'package:admin_hanaang/features/http/http_provider.dart';
import 'package:admin_hanaang/features/storage/provider/storage_provider.dart';
import 'package:admin_hanaang/features/storage/service/storage_service.dart';
import 'package:admin_hanaang/models/response_data.dart';
import 'package:admin_hanaang/utils/constant/base_url.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';

import '../../../models/retur.dart';

final returProvider = Provider<ReturApi>((ref) {
  return ReturApi(ref.watch(httpProvider), ref.watch(storageProvider));
});

class ReturApi {
  final IOClient _http;
  final SecureStorage storage;

  ReturApi(this._http, this.storage);

  Future<Either<String, Map>> getRetur(String statusName, int page) async {
    final role =  await storage.getRoleName();
    Uri url = Uri.parse("$BASEURL/$role/retur/$statusName?page=$page");

    final token = await storage.read("token");

    Map<String, String> header = {"Authorization": "Bearer $token"};

    Response response = await _http.get(url, headers: header);

    if (response.statusCode == 200) {
      List result = jsonDecode(response.body)['data'];
      int currentPage = jsonDecode(response.body)['meta']['current_page'];
      int lastPage = jsonDecode(response.body)['meta']['last_page'];
      int total = jsonDecode(response.body)['meta']['total'];
      List<Retur> data = result.map((e) => Retur.fromJson(e)).toList();
      return Right({
        "data": data,
        "current_page": currentPage,
        "last_page": lastPage,
        "total": total
      });
    } else {
      return const Left("gagal memuat data Retur");
    }
  }

  Future<Either<String, ResponseData>> searchRetur(String query) async {
    final role =  await storage.getRoleName();
    Uri url = Uri.parse("$BASEURL/$role/retur/search");

    final token = await storage.read("token");

    Map<String, String> header = {"Authorization": "Bearer $token"};
    Response response =
        await _http.post(url, body: {"search": query}, headers: header);

    if (response.statusCode == 200) {
      List result = jsonDecode(response.body)['data'];
      int total = jsonDecode(response.body)['meta']['total'];
      List<Retur> data = result.map((e) => Retur.fromJson(e)).toList();
      return Right(ResponseData(data: data, total: total));
    } else {
      return const Left("gagal mencari data Retur");
    }
  }

  Future<Either<String, bool>> createAcceptRetur(String returId) async {
    final role =  await storage.getRoleName();
    Uri url = Uri.parse("$BASEURL/$role/retur/accept/$returId");

    final token = await storage.read("token");

    Map<String, String> header = {"Authorization": "Bearer $token"};
    Response response = await _http.post(url, headers: header);
    if (response.statusCode == 200) {
      return const Right(true);
    } else {
      return const Left("gagal terima Retur");
    }
  }

  Future<Either<String, bool>> createRejectRetur(String returId,
      {required String messageReject}) async {
    final role =  await storage.getRoleName();
    Uri url = Uri.parse("$BASEURL/$role/retur/reject/$returId");

    final token = await storage.read("token");
    Map data = {"message_rejected": messageReject};
    Map<String, String> header = {"Authorization": "Bearer $token"};
    Response response = await _http.post(url, body: data, headers: header);
    if (response.statusCode == 200) {
      return const Right(true);
    } else {
      return const Left("gagal tolak Retur");
    }
  }

  Future<Either<String, bool>> takingRetur(String returId,
      {required String quantity}) async {
    final role =  await storage.getRoleName();
    Uri url = Uri.parse("$BASEURL/$role/retur/taking/$returId");

    final token = await storage.read("token");
    Map data = {"quantity": quantity};
    Map<String, String> header = {"Authorization": "Bearer $token"};
    Response response = await _http.post(url, body: data, headers: header);
    if (response.statusCode == 200) {
      return const Right(true);
    } else {
      return const Left("gagal mengambil Retur");
    }
  }
}
