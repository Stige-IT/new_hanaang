import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:admin_hanaang/features/http/http_provider.dart';
import 'package:admin_hanaang/features/storage/provider/storage_provider.dart';
import 'package:admin_hanaang/models/suplayer.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as httpp;
import 'package:http/io_client.dart';

import '../../../utils/constant/base_url.dart';
import '../../../utils/helper/formatted_role.dart';
import '../../storage/service/storage_service.dart';

final suplayerProvider = Provider<SuplayerApi>((ref) {
  return SuplayerApi(ref.watch(httpProvider), ref.watch(storageProvider));
});

class SuplayerApi {
  final IOClient http;
  final SecureStorage storage;

  SuplayerApi(this.http, this.storage);

  Future<Either<String, List<Suplayer>>> getSuplayerData() async {
    try {
      final typeAdmin = formattedPath(await storage.read('type_admin'));

      Uri url = Uri.parse("$BASEURL/$typeAdmin/suplayer");
      final String token = await storage.read('token');
      Map<String, String> headers = {"Authorization": "Bearer $token"};

      Response response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        List result = jsonDecode(response.body)['data'];
        List<Suplayer> data = result.map((e) => Suplayer.fromJson(e)).toList();
        return Right(data);
      }else if(response.statusCode == 403){
        return const Left("Tidak punya Hak Akses");
      }  else {
        return const Left("gagal memuat data suplayer");
      }
    } catch (e) {
      return Left("Error $e");
    }
  }

  Future<Either<String, Suplayer>> getSuplayerDataById(
      String suplayerId) async {
    final typeAdmin = formattedPath(await storage.read('type_admin'));

    Uri url = Uri.parse("$BASEURL/$typeAdmin/suplayer/show/$suplayerId");
    final String token = await storage.read('token');
    Map<String, String> headers = {"Authorization": "Bearer $token"};

    Response response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body)['data'];
      Suplayer data = Suplayer.fromJson(result);
      return Right(data);
    }else if(response.statusCode == 403){
      return const Left("Tidak punya Hak Akses");
    }  else {
      return const Left("gagal memuat suplayer detail");
    }
  }

  Future<Either<String, bool>> createSuplayer(
    bool isActiveAddress, {
    File? image,
    String? name,
    String? phoneNumber,
    int? idProvince,
    int? idRegency,
    int? idDistrict,
    int? idVillage,
    String? detail,
  }) async {
    final typeAdmin = formattedPath(await storage.read('type_admin'));

    Uri url = Uri.parse("$BASEURL/$typeAdmin/suplayer/create");
    final String token = await storage.read('token');
    Map<String, String> headers = {"Authorization": "Bearer $token"};

    final request = httpp.MultipartRequest("POST", url);

    request.headers.addAll(headers);
    if (image != null) {
      request.files.add(httpp.MultipartFile(
        "image",
        image.readAsBytes().asStream(),
        image.lengthSync(),
        filename: image.path.split('/').last,
      ));
    }
    request.fields['name'] = name!;
    request.fields['phone_number'] = phoneNumber!;
    request.fields['active_address'] = (isActiveAddress ? 1 : 0).toString();

    if (isActiveAddress) {
      request.fields['province_id'] = idProvince.toString();
      request.fields['regency_id'] = idRegency.toString();
      request.fields['district_id'] = idDistrict.toString();
      request.fields['village_id'] = idVillage.toString();
      request.fields['detail'] = detail.toString();
    }

    StreamedResponse response = await request.send();
    log(await response.stream.bytesToString(), name: "RESPONE CREATE SUPLAYER");
    log(request.fields.toString());

    if (response.statusCode == 200) {
      return const Right(true);
    }else if(response.statusCode == 403){
      return const Left("Tidak punya Hak Akses");
    }  else {
      return const Left("Gagal membuat data suplayer baru");
    }
  }

  Future<Either<String, bool>> updateSuplayer(
    String idSuplayer, {
    File? image,
    String? name,
    String? phoneNumber,
    int? idProvince,
    int? idRegency,
    int? idDistrict,
    int? idVillage,
    String? detail,
  }) async {
    final typeAdmin = formattedPath(await storage.read('type_admin'));

    Uri url = Uri.parse("$BASEURL/$typeAdmin/suplayer/update/$idSuplayer");
    final String token = await storage.read('token');
    Map<String, String> headers = {"Authorization": "Bearer $token"};

    final request = httpp.MultipartRequest("POST", url);

    request.headers.addAll(headers);
    if (image != null) {
      request.files.add(httpp.MultipartFile(
        "image",
        image.readAsBytes().asStream(),
        image.lengthSync(),
        filename: image.path.split('/').last,
      ));
    }

    request.fields['name'] = name!;
    request.fields['phone_number'] = phoneNumber!;
    request.fields['province_id'] = idProvince.toString();
    request.fields['regency_id'] = idRegency.toString();
    request.fields['district_id'] = idDistrict.toString();
    request.fields['village_id'] = idVillage.toString();
    request.fields['detail'] = detail.toString();

    StreamedResponse response = await request.send();
    log(await response.stream.bytesToString(), name: "RESPONE UPDATE SUPLAYER");

    if (response.statusCode == 200) {
      return const Right(true);
    }else if(response.statusCode == 403){
      return const Left("Tidak punya Hak Akses");
    }  else {
      return const Left("Gagal memperbaharui data suplayer");
    }
  }

  Future<Either<String, bool>> deleteSuplayer(String idSuplayer) async {
    final typeAdmin = formattedPath(await storage.read("type_admin"));
    final token = await storage.read('token');
    Uri url = Uri.parse("$BASEURL/$typeAdmin/suplayer/delete/$idSuplayer");
    Map<String, String> header = {"Authorization": "Bearer $token"};
    Response response = await http.delete(url, headers: header);
    if (response.statusCode == 200) {
      return const Right(true);
    }else if(response.statusCode == 403){
      return const Left("Tidak punya Hak Akses");
    }else if(response.statusCode == 401){
      final msg = jsonDecode(response.body)['data'];
      return Left(msg);
    }  else {
      return const Left("Gagal menghapus suplayer");
    }
  }
}
