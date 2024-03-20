import 'dart:convert';
import 'dart:developer';

import 'package:admin_hanaang/features/http/http_provider.dart';
import 'package:admin_hanaang/features/storage/provider/storage_provider.dart';
import 'package:admin_hanaang/features/storage/service/storage_service.dart';
import 'package:admin_hanaang/models/penerimaan_barang/detail_penerimaan_barang.dart';
import 'package:admin_hanaang/models/penerimaan_barang/penerimaan_barang.dart';
import 'package:admin_hanaang/utils/constant/base_url.dart';
import 'package:admin_hanaang/utils/helper/formatted_role.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';

final penerimaanBarangProvider = Provider<PenerimaanBarangApi>((ref) {
  return PenerimaanBarangApi(
      ref.watch(httpProvider), ref.watch(storageProvider));
});

class PenerimaanBarangApi {
  final IOClient _http;
  final SecureStorage _storage;

  PenerimaanBarangApi(this._http, this._storage);

  Future<Either<String, Map<String, dynamic>>> getData({int? page}) async {
    final typeAdmin = formattedPath(await _storage.read("type_admin"));
    String token = await _storage.read("token");
    Uri url = Uri.parse("$BASEURL/$typeAdmin/penerimaan-barang?page=$page");
    Map<String, String> header = {"Authorization": "Bearer $token"};
    Response response = await _http.get(url, headers: header);
    if (response.statusCode == 200) {
      List result = jsonDecode(response.body)['data']['data'];
      List<PenerimaanBarang> data =
          result.map((e) => PenerimaanBarang.fromJson(e)).toList();
      return Right({
        "data": data,
        "current_page": jsonDecode(response.body)['data']['current_page'],
        "last_page": jsonDecode(response.body)['data']['last_page'],
        "total": jsonDecode(response.body)['data']['total'],
      });
    }else if(response.statusCode == 403){
      return const Left("Tidak punya Hak Akses");
    }
    return const Left("gagal memuat data penerimaan barang");
  }

  Future<Either<String, DetailPenerimaanBarang>> getDetailData(
      String id) async {
    final typeAdmin = formattedPath(await _storage.read("type_admin"));
    String token = await _storage.read("token");
    Uri url = Uri.parse("$BASEURL/$typeAdmin/penerimaan-barang/show/$id");
    Map<String, String> header = {"Authorization": "Bearer $token"};
    Response response = await _http.get(url, headers: header);
    log(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body)['data'];
      DetailPenerimaanBarang data = DetailPenerimaanBarang.fromJson(result);
      return Right(data);
    }else if(response.statusCode == 403){
      return const Left("Tidak punya Hak Akses");
    }
    return const Left("gagal memuat detail data penerimaan barang");
  }

  Future<Either<String, bool>> createData({
    required List<String> rawMaterialId,
    required List<int> prices,
    required List<int> quantities,
  }) async {
    final typeAdmin = formattedPath(await _storage.read("type_admin"));
    String token = await _storage.read("token");
    Uri url = Uri.parse("$BASEURL/$typeAdmin/penerimaan-barang/create");
    Map<String, String> header = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json"
    };
    Map data = {
      "raw_material_id": rawMaterialId,
      "price": prices,
      "quantity": quantities,
    };

    Response response =
        await _http.post(url, body: jsonEncode(data), headers: header);
    if (response.statusCode == 200) {
      return const Right(true);
    }else if(response.statusCode == 403){
      return const Left("Tidak punya Hak Akses");
    }
    return const Left("gagal membuat data penerimaan barang");
  }
}
