import 'dart:convert';
import 'dart:io';

import 'package:admin_hanaang/features/http/http_provider.dart';
import 'package:admin_hanaang/features/http/http_request_client.dart';
import 'package:admin_hanaang/features/storage/provider/storage_provider.dart';
import 'package:admin_hanaang/models/admin_hanaang.dart';
import 'package:admin_hanaang/utils/helper/formatted_role.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';

import '../../../models/detail_admin_hanaang.dart';
import '../../../utils/constant/base_url.dart';
import '../../storage/service/storage_service.dart';

final adminHanaangProvider = Provider<AdminHanaangApi>((ref) {
  return AdminHanaangApi(
    ref.watch(httpRequestProvider),
    ref.watch(httpProvider),
    ref.watch(storageProvider),
  );
});

class AdminHanaangApi {
  final HttpRequestClient _http;
  final IOClient http;
  final SecureStorage storage;

  AdminHanaangApi(this._http, this.http, this.storage);

  Future<Either<String, Map>> getAdminHanaang(
      {String? roleId, int? page}) async {
    Uri url = Uri.parse(
        "$BASEURL/super-admin/admin?roleId=${roleId ?? ''}&page=$page");

    String token = await storage.read('token');
    Map<String, String> headers = {"Authorization": "Bearer $token"};

    Response response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      List result = jsonDecode(response.body)['data'];
      List<AdminHanaang> data =
          result.map((e) => AdminHanaang.fromJson(e)).toList();
      int currentPage = jsonDecode(response.body)['meta']['current_page'];
      int lastPage = jsonDecode(response.body)['meta']['last_page'];
      int total = jsonDecode(response.body)['meta']['total'];
      return Right({
        "data": data,
        "current_page": currentPage,
        'last_page': lastPage,
        "total": total,
      });
    } else {
      return const Left("Gagal memuat admin hanaang");
    }
  }

  Future<Either<String, DetailAdminHanaang>> getDetailAdminHanaang(
      String adminHanaangId) async {
    Uri url = Uri.parse("$BASEURL/super-admin/admin/show/$adminHanaangId");

    String token = await storage.read('token');
    Map<String, String> headers = {"Authorization": "Bearer $token"};

    Response response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body)['data'];
      DetailAdminHanaang data = DetailAdminHanaang.fromJson(result);
      return Right(data);
    } else {
      return const Left("Gagal memuat detail admin hanaang");
    }
  }

  Future<Either<String, bool>> createAdminHanang(
    String roleId, {
    File? image,
    String? name,
    String? email,
    String? phoneNumber,
    String? password,
    String? passwordConfirm,
  }) async {
    final role = await storage.getRoleName();
    final url = "$BASEURL/$role/admin/create";
    Map<String, String> data = {
      "role_id": roleId,
      "name": name!,
      "email": email!,
      "phone_number": phoneNumber!,
      "password": password!,
      "password_confirmation": passwordConfirm!,
    };

    final response = await _http.multipart(
      "POST",
      url,
      data: data,
      file: image,
      fieldFile: "image",
    );

    return response.fold(
      (error) => Left(error),
      (success) => const Right(true),
    );
  }

  Future<Either<String, Map>> searchAdminHanaang(String query,
      {int? page}) async {
    final typeAdmin = formattedPath(await storage.read('type_admin'));
    final token = await storage.read('token');
    Uri url = Uri.parse("$BASEURL/$typeAdmin/admin/search?page=$page");
    Map<String, String> headers = {"Authorization": "Bearer $token"};

    Response response =
        await http.post(url, body: {"search": query}, headers: headers);

    if (response.statusCode == 200) {
      List result = jsonDecode(response.body)['data'];
      List<AdminHanaang> data =
          result.map((e) => AdminHanaang.fromJson(e)).toList();
      int currentPage = jsonDecode(response.body)['meta']['current_page'];
      int lastPage = jsonDecode(response.body)['meta']['last_page'];
      return Right({
        "data": data,
        "current_page": currentPage,
        'last_page': lastPage,
      });
    }
    return const Left("Gagal memuat data sesuai pencarian");
  }
}
