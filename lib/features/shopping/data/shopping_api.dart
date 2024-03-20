import 'dart:convert';

import 'package:admin_hanaang/features/http/http_provider.dart';
import 'package:admin_hanaang/features/storage/provider/storage_provider.dart';
import 'package:admin_hanaang/models/shopping.dart';
import 'package:admin_hanaang/utils/constant/base_url.dart';
import 'package:admin_hanaang/utils/helper/formatted_role.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/io_client.dart';

import '../../storage/service/storage_service.dart';

final shoppingProvider = Provider<ShoppingApi>((ref) {
  return ShoppingApi(ref.watch(httpProvider), ref.watch(storageProvider));
});

class ShoppingApi {
  final IOClient _http;
  final SecureStorage _storage;

  ShoppingApi(this._http, this._storage);

  Future<Either<String, Map>> getShoppingData({int? page}) async {
    page ??= 1;
    final typeAdmin = formattedPath(await _storage.read('type_admin'));
    final token = await _storage.read('token');
    final headers = {"Authorization": "Bearer $token"};

    Uri url = Uri.parse("$BASEURL/$typeAdmin/shopping?page=$page");
    final response = await _http.get(url, headers: headers);
    if (response.statusCode == 200) {
      List result = jsonDecode(response.body)['data'];
      int currentPage = jsonDecode(response.body)['meta']['current_page'];
      int lastPage = jsonDecode(response.body)['meta']['last_page'];
      int total = jsonDecode(response.body)['meta']['total'];
      List<Shopping> data = result.map((e) => Shopping.fromJson(e)).toList();
      print(data);
      return Right({
        "data": data,
        "current_page": currentPage,
        "last_page": lastPage,
        "total": total,
      });
    }
    return const Left("Gagal mengambil data belanja");
  }

  Future<Either<String, Shopping>> getShoppingDetail(
    String shoppingId,
  ) async {
    final typeAdmin = formattedPath(await _storage.read('type_admin'));
    final token = await _storage.read('token');
    final headers = {"Authorization": "Bearer $token"};

    Uri url = Uri.parse("$BASEURL/$typeAdmin/shopping/show/$shoppingId");
    final response = await _http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body)['data'];
      Shopping data = Shopping.fromJson(result);
      return Right(data);
    }
    return const Left("Gagal mengambil detail belanja");
  }

  Future<Either<String, bool>> createShoppingData({
    required List<String> itemsName,
    required List<int> quantities,
    required List<int> prices,
  }) async {
    final typeAdmin = formattedPath(await _storage.read('type_admin'));
    final token = await _storage.read('token');
    final headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };

    Map data = {
      "name": itemsName,
      "quantity": quantities,
      "price": prices,
    };
    Uri url = Uri.parse("$BASEURL/$typeAdmin/shopping/create");
    final response =
        await _http.post(url, body: jsonEncode(data), headers: headers);
    if (response.statusCode == 200) {
      return const Right(true);
    }
    return const Left("Gagal membuat data belanja");
  }
}
