import 'dart:convert';

import 'package:admin_hanaang/features/http/http_provider.dart';
import 'package:admin_hanaang/features/storage/provider/storage_provider.dart';
import 'package:admin_hanaang/models/manage_access.dart';
import 'package:admin_hanaang/utils/constant/base_url.dart';
import 'package:admin_hanaang/utils/helper/formatted_role.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/io_client.dart';

import '../../storage/service/storage_service.dart';

final manageAccessProvider = Provider<ManageAccessApi>((ref) {
  return ManageAccessApi(ref.watch(httpProvider), ref.watch(storageProvider));
});

class ManageAccessApi {
  final IOClient _http;
  final SecureStorage _storage;

  ManageAccessApi(this._http, this._storage);

  Future<Either<String, List<ManageAccess>>> getDataManageAccess(
      {String? typeId}) async {
    final typeAdmin = formattedPath(await _storage.read("type_admin"));
    final token = await _storage.read("token");
    Uri url = Uri.parse("$BASEURL/$typeAdmin/warehouse-access?typeId=$typeId");
    Map<String, String> header = {"Authorization": "Bearer $token"};

    final response = await _http.get(url, headers: header);
    if (response.statusCode == 200) {
      List result = jsonDecode(response.body)['data'];
      List<ManageAccess> data =
          result.map((e) => ManageAccess.fromJson(e)).toList();
      return Right(data);
    }
    return const Left("Gagal memuat data manage akses");
  }

  Future<Either<String, ManageAccess>> getDetailDataManageAccess(
      {String? manageAccessId}) async {
    final typeAdmin = formattedPath(await _storage.read("type_admin"));
    final token = await _storage.read("token");
    Uri url =
        Uri.parse("$BASEURL/$typeAdmin/warehouse-access/show/$manageAccessId");
    Map<String, String> header = {"Authorization": "Bearer $token"};

    final response = await _http.get(url, headers: header);
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body)['data'];
      ManageAccess data = ManageAccess.fromJson(result);
      return Right(data);
    }
    return const Left("Gagal memuat detail data manage akses");
  }

  Future<Either<String, bool>> updateManageAccess(
    String manageAccessId, {
    required String create,
    required String read,
    required String update,
    required String delete,
  }) async {
    final typeAdmin = formattedPath(await _storage.read("type_admin"));
    final token = await _storage.read("token");
    Uri url =
        Uri.parse("$BASEURL/$typeAdmin/warehouse-access/update/$manageAccessId");
    Map<String, String> header = {"Authorization": "Bearer $token"};

    Map data = {
      "create": create,
      "read": read,
      "update": update,
      "delete": delete,
    };
    final response = await _http.post(url, body: data, headers: header);
    if (response.statusCode == 200) {
      return const Right(true);
    }
    return const Left("Gagal memperbaharui data manage akses");
  }
}
