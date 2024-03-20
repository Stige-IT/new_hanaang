import 'dart:convert';
import 'dart:io';

import 'package:admin_hanaang/features/http/http_provider.dart';
import 'package:admin_hanaang/features/storage/provider/storage_provider.dart';
import 'package:admin_hanaang/features/storage/service/storage_service.dart';
import 'package:admin_hanaang/models/banner_data.dart';
import 'package:admin_hanaang/utils/constant/base_url.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as httpp;
import 'package:http/io_client.dart';

final bannerProvider = Provider<BannerApi>((ref) {
  return BannerApi(ref.watch(httpProvider), ref.watch(storageProvider));
});

class BannerApi {
  final IOClient http;
  final SecureStorage storage;

  BannerApi(this.http, this.storage);

  Future<Either<String, List<BannerData>>> getBannerdata() async {
    Uri url = Uri.parse("$BASEURL/super-admin/banner");
    try {
      String token = await storage.read('token');
      Map<String, String> headers = {"Authorization": "Bearer $token"};

      Response response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        List result = jsonDecode(response.body)['data'];
        List<BannerData> data =
            result.map((e) => BannerData.fromJson(e)).toList();

        return Right(data);
      } else {
        return const Left("Gagal mengambil data banner");
      }
    } catch (e) {
      return Left("Error $e");
    }
  }

  Future<Either<String, BannerData>> getBannerdataById(BannerData data) async {
    Uri url = Uri.parse("$BASEURL/super-admin/banner/${data.id}");
    try {
      String token = await storage.read('token');
      Map<String, String> headers = {"Authorization": "Bearer $token"};

      Response response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        BannerData data =
            BannerData.fromJson(jsonDecode(response.body)['data']);
        return Right(data);
      } else {
        return const Left("Gagal mengambil data banner");
      }
    } catch (e) {
      return Left("Error $e");
    }
  }

  Future<Either<String, bool>> createBannerdata({
    required String detail,
    required File image,
  }) async {
    Uri url = Uri.parse("$BASEURL/super-admin/banner/create");
    String token = await storage.read('token');
    Map<String, String> header = {"Authorization": "Bearer $token"};

    final request = httpp.MultipartRequest("POST", url);
    request.headers.addAll(header);

    request.fields['detail'] = detail;
    request.files.add(
      httpp.MultipartFile(
        "image",
        image.readAsBytes().asStream(),
        image.lengthSync(),
        filename: image.path.split('/').last,
      ),
    );

    final response = await request.send();

    if (response.statusCode == 200) {
      return const Right(true);
    }
    return const Left("Gagal membuat banner");
  }

  Future<Either<String, bool>> updateBannerdata(
    BannerData data, {
    required String detail,
    File? image,
  }) async {
    Uri url = Uri.parse("$BASEURL/super-admin/banner/update/${data.id}");
    String token = await storage.read('token');
    Map<String, String> header = {"Authorization": "Bearer $token"};

    final request = httpp.MultipartRequest("POST", url);
    request.headers.addAll(header);

    request.fields['detail'] = detail;
    if (image != null) {
      request.files.add(
        httpp.MultipartFile(
          "image",
          image.readAsBytes().asStream(),
          image.lengthSync(),
          filename: image.path.split('/').last,
        ),
      );
    }

    final response = await request.send();

    if (response.statusCode == 200) {
      return const Right(true);
    }
    return const Left("Gagal memperbaharui banner");
  }

  Future<Either<String, bool>> deleteBannerdata(BannerData data) async {
    Uri url = Uri.parse("$BASEURL/super-admin/banner/delete/${data.id}");
    String token = await storage.read('token');

    Map<String, String> headers = {'Authorization': "Bearer $token"};

    Response response = await http.delete(url, headers: headers);
    if (response.statusCode == 200) {
      return const Right(true);
    }
    return const Left("Gagal menghapus banner");
  }
}
