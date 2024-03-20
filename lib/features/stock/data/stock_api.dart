import 'dart:convert';

import 'package:admin_hanaang/features/http/http_provider.dart';
import 'package:admin_hanaang/features/storage/provider/storage_provider.dart';
import 'package:admin_hanaang/utils/constant/base_url.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';

import '../../storage/service/storage_service.dart';

final stockProvider = Provider<StockApi>((ref) {
  return StockApi(ref.watch(httpProvider), ref.watch(storageProvider));
});

class StockApi {
  final IOClient http;
  final SecureStorage storage;

  StockApi(this.http, this.storage);

  Future<Either<String, int>> getStock({required String type}) async {
    final role = await storage.getRoleName();
    Uri url = Uri.parse("$BASEURL/$role/product/$type");
    final token = await storage.read("token");
    Map<String, String> header = {"Authorization": "Bearer $token"};
    Response response = await http.get(url, headers: header);
    if (response.statusCode == 200) {
      final int result = int.parse(jsonDecode(response.body)['data']);
      return Right(result);
    }
    return const Left('Gagal get Stock');
  }
}
