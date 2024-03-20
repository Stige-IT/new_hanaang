import 'dart:convert';

import 'package:admin_hanaang/features/http/http_provider.dart';
import 'package:admin_hanaang/features/storage/provider/storage_provider.dart';
import 'package:admin_hanaang/models/price_product.dart';
import 'package:admin_hanaang/utils/constant/base_url.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';

import '../../storage/service/storage_service.dart';

final priceProdcutProvider = Provider<PriceProductApi>((ref) {
  return PriceProductApi(ref.watch(httpProvider), ref.watch(storageProvider));
});

class PriceProductApi {
  final IOClient http;
  final SecureStorage storage;

  PriceProductApi(this.http, this.storage);

  Future<Either<String, List<PriceProduct>>> getPriceProduct(
      String nameTypePrice) async {
    final role = await storage.getRoleName();
    Uri url = Uri.parse("$BASEURL/$role/price/show/$nameTypePrice");
    String token = await storage.read('token');
    Map<String, String> header = {"Authorization": "Bearer $token"};

    Response response = await http.get(url, headers: header);
    if (response.statusCode == 200) {
      List result = jsonDecode(response.body)['data'];
      List<PriceProduct> data =
          result.map((e) => PriceProduct.fromJson(e)).toList();
      return Right(data);
    } else {
      return const Left("Gagal memuat data harga produk");
    }
  }

  Future<Either<String, int>> checkPriceProduct(
      String userId, int quantity) async {
    final role = await storage.getRoleName();
    Uri url = Uri.parse("$BASEURL/$role/price/check");
    String token = await storage.read('token');
    Map<String, String> header = {"Authorization": "Bearer $token"};

    Response response = await http.post(url,
        body: {
          "user_id": userId,
          "quantity": quantity.toString(),
        },
        headers: header);
    if (response.statusCode == 200) {
      String result = jsonDecode(response.body)['data'];
      return Right(int.parse(result));
    } else {
      return const Left("Gagal memuat harga produk");
    }
  }

  Future<Either<String, bool>> createPriceProduct({
    required String namePriceType,
    required String price,
    required String minimumOrder,
  }) async {
    final role = await storage.getRoleName();
    Uri url = Uri.parse("$BASEURL/$role/price/create");
    String token = await storage.read('token');
    Map<String, String> header = {"Authorization": "Bearer $token"};
    Map data = {
      "price_type": namePriceType,
      "price": price,
      "minimum_order": minimumOrder,
    };

    Response response = await http.post(url, body: data, headers: header);
    if (response.statusCode == 200) {
      return const Right(true);
    } else {
      return const Left("Gagal membuat data harga produk");
    }
  }

  Future<Either<String, bool>> updatePriceProduct(
    String priceProductId, {
    required String namePriceType,
    required String price,
    required String minimumOrder,
  }) async {
    final role = await storage.getRoleName();
    Uri url = Uri.parse("$BASEURL/$role/price/update/$priceProductId");
    String token = await storage.read('token');
    Map<String, String> header = {"Authorization": "Bearer $token"};
    Map data = {
      "price_type": namePriceType,
      "price": price,
      "minimum_order": minimumOrder,
    };

    Response response = await http.post(url, body: data, headers: header);
    if (response.statusCode == 200) {
      return const Right(true);
    } else {
      return const Left("Gagal memperbaharui data harga produk");
    }
  }

  Future<Either<String, bool>> deletePriceProduct({
    required String priceId,
  }) async {
    final role = await storage.getRoleName();
    Uri url = Uri.parse("$BASEURL/$role/price/delete/$priceId");
    String token = await storage.read('token');
    Map<String, String> header = {"Authorization": "Bearer $token"};

    Response response = await http.delete(url, headers: header);
    if (response.statusCode == 200) {
      return const Right(true);
    } else if (response.statusCode == 401) {
      return const Left("Default harga tidak bisa dihapus");
    } else {
      return const Left("Gagal menghapus data harga produk");
    }
  }
}
