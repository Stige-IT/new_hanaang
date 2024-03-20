import 'dart:convert';

import 'package:admin_hanaang/features/http/http_provider.dart';
import 'package:admin_hanaang/features/storage/provider/storage_provider.dart';
import 'package:admin_hanaang/models/unit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';

import '../../../utils/constant/base_url.dart';
import '../../../utils/helper/formatted_role.dart';
import '../../storage/service/storage_service.dart';

final unitsProvider = Provider<UnitApi>((ref) {
  return UnitApi(ref.watch(httpProvider), ref.watch(storageProvider));
});

class UnitApi {
  final IOClient http;
  final SecureStorage storage;

  UnitApi(this.http, this.storage);

  Future<Either<String, List<UnitModel>>> getUnits() async {
    final typeAdmin = formattedPath(await storage.read('type_admin'));
    Uri url = Uri.parse("$BASEURL/$typeAdmin/unit");
    String token = await storage.read('token');
    Map<String, String> header = {"Authorization": "Bearer $token"};

    Response response = await http.get(url, headers: header);
    if (response.statusCode == 200) {
      List result = jsonDecode(response.body)['data'];
      List<UnitModel> data = result.map((e) => UnitModel.fromJson(e)).toList();
      return Right(data);
    }else if(response.statusCode == 403){
      return const Left("Tidak punya Hak Akses");
    }  else {
      return const Left("Gagal memuat data units");
    }
  }

  Future<Either<String, UnitModel>> getUnit(String unitId) async {
    final typeAdmin = formattedPath(await storage.read('type_admin'));
    Uri url = Uri.parse("$BASEURL/$typeAdmin/unit/show/$unitId");
    String token = await storage.read('token');
    Map<String, String> header = {"Authorization": "Bearer $token"};

    Response response = await http.get(url, headers: header);
    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body)['data'];
      UnitModel data = UnitModel.fromJson(result);
      return Right(data);
    }else if(response.statusCode == 403){
      return const Left("Tidak punya Hak Akses");
    }  else {
      return const Left("Gagal memuat data unit");
    }
  }

  Future<Either<String, bool>> createUnit({required String name}) async {
    final typeAdmin = formattedPath(await storage.read('type_admin'));
    Uri url = Uri.parse("$BASEURL/$typeAdmin/unit/create");
    String token = await storage.read('token');
    Map<String, String> header = {"Authorization": "Bearer $token"};
    Map data = {"name": name};
    Response response = await http.post(url, body: data, headers: header);
    if (response.statusCode == 200) {
      return const Right(true);
    }else if(response.statusCode == 403){
      return const Left("Tidak punya Hak Akses");
    }  else {
      return const Left("Gagal membuat data unit");
    }
  }

  Future<Either<String, bool>> updateUnit(String unitId,
      {required String name}) async {
    final typeAdmin = formattedPath(await storage.read('type_admin'));
    Uri url = Uri.parse("$BASEURL/$typeAdmin/unit/update/$unitId");
    String token = await storage.read('token');
    Map<String, String> header = {"Authorization": "Bearer $token"};
    Map data = {"name": name};

    Response response = await http.post(url, body: data, headers: header);
    if (response.statusCode == 200) {
      return const Right(true);
    }else if(response.statusCode == 403){
      return const Left("Tidak punya Hak Akses");
    }  else {
      return const Left("Gagal memperbaharui data unit");
    }
  }

  Future<Either<String, bool>> deleteUnit(String unitId) async {
    final typeAdmin = formattedPath(await storage.read('type_admin'));
    Uri url = Uri.parse("$BASEURL/$typeAdmin/unit/delete/$unitId");
    String token = await storage.read('token');
    Map<String, String> header = {"Authorization": "Bearer $token"};

    Response response = await http.delete(url, headers: header);
    switch (response.statusCode) {
      case 200:
        return const Right(true);
      case 404:
        return const Left("Data tidak ditemukan");
      case 401:
        return const Left("Data masih digunakan pada bahan baku");
      case 403:
        return const Left("Tidak punya hak akses");
      default:
        return const Left("Gagal menghapus data unit");
    }
  }
}
