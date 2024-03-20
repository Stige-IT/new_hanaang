import 'package:admin_hanaang/features/storage/provider/storage_provider.dart';
import 'package:admin_hanaang/features/storage/service/storage_service.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';

import '../../../utils/constant/base_url.dart';
import '../../http/http_provider.dart';

final authApiProvider = Provider<AuthApi>((ref) {
  return AuthApi(ref.watch(httpProvider), ref.watch(storageProvider));
});

class AuthApi {
  final IOClient http;
  final SecureStorage storage;
  const AuthApi(this.http, this.storage);

  Future<Either<String, String>> login({
    required String email,
    required String password,
  }) async {
    Uri url = Uri.parse("$BASEURL/login");
    Map data = {"email": email, "password": password};
    Response response = await http.post(url, body: data);

    if (response.statusCode == 200) {
      final result = response.body;
      return Right(result);
    } else {
      return const Left(
          "Login Gagal, perhatikan kembali email dan password Anda");
    }
  }

  Future<Either<String, String>> logout() async {
    Uri url = Uri.parse("$BASEURL/logout");

    final token = await storage.read("token");
    Map<String, String> data = {"Authorization": "Bearer $token"};
    Response response = await http.post(url, headers: data);
    await storage.deleteAll();

    if (response.statusCode == 200) {
      final result = response.body;
      return Right(result);
    } else {
      return const Left("Logout Gagal");
    }
  }
}
