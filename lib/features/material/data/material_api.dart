import 'dart:convert';

import 'package:admin_hanaang/features/http/http_provider.dart';
import 'package:admin_hanaang/features/storage/provider/storage_provider.dart';
import 'package:admin_hanaang/models/material_detail.dart';
import 'package:admin_hanaang/models/material_model.dart';
import 'package:admin_hanaang/models/penerimaan_barang/history_penerimaan_barang.dart';
import 'package:admin_hanaang/utils/constant/base_url.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';

import '../../../models/suplayer.dart';
import '../../../utils/helper/formatted_role.dart';
import '../../storage/service/storage_service.dart';

final materialProvider = Provider<MaterialApi>((ref) {
  return MaterialApi(ref.watch(httpProvider), ref.watch(storageProvider));
});

class MaterialApi {
  final IOClient http;
  final SecureStorage storage;

  MaterialApi(this.http, this.storage);

  Future<Either<String, List<MaterialModel>>> getMaterials() async {
    final typeAdmin = formattedPath(await storage.read('type_admin'));
    Uri url = Uri.parse("$BASEURL/$typeAdmin/raw-material");
    String token = await storage.read('token');
    Map<String, String> header = {"Authorization": "Bearer $token"};

    Response response = await http.get(url, headers: header);
    if (response.statusCode == 200) {
      List result = jsonDecode(response.body)['data'];
      List<MaterialModel> data =
          result.map((e) => MaterialModel.fromJson(e)).toList();
      return Right(data);
    }else if(response.statusCode == 403){
      return const Left("Tidak punya Hak Akses");
    } else {
      return const Left("Gagal memuat data material");
    }
  }

  Future<Either<String, MaterialDetail>> getMaterial(String materialId) async {
    final typeAdmin = formattedPath(await storage.read('type_admin'));
    Uri url = Uri.parse("$BASEURL/$typeAdmin/raw-material/show/$materialId");
    String token = await storage.read('token');
    Map<String, String> header = {"Authorization": "Bearer $token"};

    Response response = await http.get(url, headers: header);

    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body)['data'];
      MaterialDetail data = MaterialDetail.fromJson(result);
      return Right(data);
    }else if(response.statusCode == 403){
      return const Left("Tidak punya Hak Akses");
    }  else {
      return const Left("Gagal memuat data material");
    }
  }

  Future<Either<String, Suplayer>> getDetailSuplayer(String materialId) async {
    final typeAdmin = formattedPath(await storage.read('type_admin'));
    Uri url =
        Uri.parse("$BASEURL/$typeAdmin/raw-material/show/$materialId/suplayer");
    String token = await storage.read('token');
    Map<String, String> header = {"Authorization": "Bearer $token"};

    Response response = await http.get(url, headers: header);

    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body)['data'];
      Suplayer data = Suplayer.fromJson(result);
      return Right(data);
    }else if(response.statusCode == 403){
      return const Left("Tidak punya Hak Akses");
    }  else {
      return const Left("Gagal memuat data material");
    }
  }

  Future<Either<String, Map>> getHistoryPenerimaanBarang(String materialId,
      {int? page}) async {
    final typeAdmin = formattedPath(await storage.read('type_admin'));
    Uri url = Uri.parse(
        "$BASEURL/$typeAdmin/raw-material/history/penerimaan-barang/$materialId?page=$page");
    String token = await storage.read('token');
    Map<String, String> header = {"Authorization": "Bearer $token"};

    Response response = await http.get(url, headers: header);
    if (response.statusCode == 200) {
      List result = jsonDecode(response.body)['data']['data'];
      List<HistoryPenerimaanBarang> data =
          result.map((e) => HistoryPenerimaanBarang.fromJson(e)).toList();

      int currentPage = jsonDecode(response.body)['data']['current_page'];
      int lastPage = jsonDecode(response.body)['data']['last_page'];

      return Right({
        "data": data,
        "current_page": currentPage,
        "last_page": lastPage,
      });
    }else if(response.statusCode == 403){
      return const Left("Tidak punya Hak Akses");
    }  else {
      return const Left("Gagal memuat data material");
    }
  }

  Future<Either<String, bool>> createMaterial({
    required String suplayerId,
    required String name,
    required String unitId,
    required String stock,
    required String unitPrice,
  }) async {
    final typeAdmin = formattedPath(await storage.read('type_admin'));
    Uri url = Uri.parse("$BASEURL/$typeAdmin/raw-material/create");
    String token = await storage.read('token');
    Map<String, String> header = {"Authorization": "Bearer $token"};
    Map data = {
      "suplayer_id": suplayerId,
      "name": name,
      "unit_id": unitId,
      "stock": stock,
      "unit_price": unitPrice,
    };

    Response response = await http.post(url, body: data, headers: header);

    if (response.statusCode == 200) {
      return const Right(true);
    }else if(response.statusCode == 403){
      return const Left("Tidak punya Hak Akses");
    }  else {
      return const Left("Gagal memuat data material");
    }
  }

  Future<Either<String, bool>> updateMaterial(
    String materialId, {
    required String name,
    required String unitId,
    required String unitPrice,
  }) async {
    final typeAdmin = formattedPath(await storage.read('type_admin'));
    final token = await storage.read('token');
    Uri url = Uri.parse("$BASEURL/$typeAdmin/raw-material/update/$materialId");
    Map data = {
      "name": name,
      "unit_id": unitId,
      "unit_price": unitPrice,
    };
    Response response = await http.post(
      url,
      body: data,
      headers: {"Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      return const Right(true);
    }else if(response.statusCode == 403){
      return const Left("Tidak punya Hak Akses");
    }
    return const Left("Gagal memperbaharui data material");
  }

  Future<Either<String, bool>> deleteMaterial(String materialId) async {
    final typeAdmin = formattedPath(await storage.read('type_admin'));
    Uri url = Uri.parse("$BASEURL/$typeAdmin/raw-material/delete/$materialId");
    String token = await storage.read('token');
    Map<String, String> header = {"Authorization": "Bearer $token"};

    Response response = await http.delete(url, headers: header);
    if (response.statusCode == 200) {
      return const Right(true);
    }else if(response.statusCode == 403){
      return const Left("Tidak punya Hak Akses");
    }  else {
      return const Left("Gagal memuat data material");
    }
  }
}
