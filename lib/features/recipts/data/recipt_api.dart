import 'dart:convert';

import 'package:admin_hanaang/features/http/http_provider.dart';
import 'package:admin_hanaang/features/storage/provider/storage_provider.dart';
import 'package:admin_hanaang/features/storage/service/storage_service.dart';
import 'package:admin_hanaang/models/item_reciept.dart';
import 'package:admin_hanaang/models/recipt.dart';
import 'package:admin_hanaang/utils/constant/base_url.dart';
import 'package:admin_hanaang/utils/helper/formatted_role.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';

import '../../../models/recipt_detail.dart';

final reciptProvider = Provider<ReciptApi>((ref) {
  return ReciptApi(ref.watch(httpProvider), ref.watch(storageProvider));
});

class ReciptApi {
  final IOClient _http;
  final SecureStorage _storage;

  ReciptApi(this._http, this._storage);

  Future<Either<String, Map>> getRecipts({int? page}) async {
    String typeAdmin = formattedPath(await _storage.read("type_admin"));

    Uri url = Uri.parse("$BASEURL/$typeAdmin/recipe?page=$page");
    String token = await _storage.read('token');
    Map<String, String> header = {"Authorization": "Bearer $token"};

    Response response = await _http.get(url, headers: header);
    if (response.statusCode == 200) {
      List result = jsonDecode(response.body)['data'];
      List<Recipt> data = result.map((e) => Recipt.fromJson(e)).toList();
      int currentPage = jsonDecode(response.body)['meta']['current_page'];
      int lastPage = jsonDecode(response.body)['meta']['last_page'];
      return Right({
        "data": data,
        "current_page": currentPage,
        "last_page": lastPage,
      });
    }else if(response.statusCode == 403){
      return const Left("Tidak punya Hak Akses");
    }  else {
      return const Left("Gagal memuat recipt data");
    }
  }

  Future<Either<String, ReciptDetail>> getRecipt(String reciptId) async {
    final typeAdmin = formattedPath(await _storage.read("type_admin"));
    Uri url = Uri.parse("$BASEURL/$typeAdmin/recipe/show/$reciptId");
    String token = await _storage.read('token');
    Map<String, String> header = {"Authorization": "Bearer $token"};

    Response response = await _http.get(url, headers: header);
    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body)['data'];
      ReciptDetail data = ReciptDetail.fromJson(result);
      return Right(data);
    }else if(response.statusCode == 403){
      return const Left("Tidak punya Hak Akses");
    }  else {
      return const Left("Gagal memuat recipt detail data");
    }
  }

  Future<Either<String, bool>> createRecipt(List<ItemRecipt> recipts) async {
    final typeAdmin = formattedPath(await _storage.read("type_admin"));
    Uri url = Uri.parse("$BASEURL/$typeAdmin/recipe/create");
    String token = await _storage.read('token');
    final data = recipts.map((recipt) => recipt.toJson()).toList();
    Map<String, String> header = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json"
    };

    Response response =
        await _http.post(url, body: jsonEncode(data), headers: header);
    if (response.statusCode == 200) {
      return const Right(true);
    }else if(response.statusCode == 403){
      return const Left("Tidak punya Hak Akses");
    }  else {
      return const Left("Gagal memuat recipt detail data");
    }
  }
}
