import 'dart:convert';

import 'package:admin_hanaang/features/http/http_provider.dart';
import 'package:admin_hanaang/features/storage/provider/storage_provider.dart';
import 'package:admin_hanaang/features/storage/service/storage_service.dart';
import 'package:admin_hanaang/utils/constant/base_url.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';

final passwordProvider = Provider<PasswordApi>((ref) {
  return PasswordApi(ref.watch(storageProvider), ref.watch(httpProvider));
});

class PasswordApi {
  final SecureStorage storage;
  final IOClient http;

  PasswordApi(this.storage, this.http);

  Future<Either<String, bool>> updatePassword({
    String? oldPassword,
    String? newPassword,
    String? confirmPassword,
  }) async {
    try {
      Uri url = Uri.parse("$BASEURL/update/password");
      final token = await storage.read("token");
      Map<String, String> header = {"Authorization": "Bearer $token"};

      Map data = {
        "old_password": oldPassword,
        "new_password": newPassword,
        "new_password_confirmation": confirmPassword,
      };
      Response response = await http.post(url, body: data, headers: header);
      final status = jsonDecode(response.body)['message'];

      if (response.statusCode == 200 && status == "success") {
        return const Right(true);
      } else {
        return const Left("Password tidak sesuai");
      }
    } catch (e) {
      return Left("$e");
    }
  }
}
