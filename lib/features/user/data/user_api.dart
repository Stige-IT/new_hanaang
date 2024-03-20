import 'dart:convert';
import 'dart:io';

import 'package:admin_hanaang/features/http/http_provider.dart';
import 'package:admin_hanaang/features/storage/provider/storage_provider.dart';
import 'package:admin_hanaang/features/storage/service/storage_service.dart';
import 'package:admin_hanaang/models/user.dart';
import 'package:admin_hanaang/models/user_address.dart';
import 'package:admin_hanaang/utils/constant/base_url.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as httpp;
import 'package:http/io_client.dart';

final userProvider = Provider<UserApi>((ref) {
  return UserApi(ref.watch(httpProvider), ref.watch(storageProvider));
});

class UserApi {
  final IOClient http;
  final SecureStorage storage;

  UserApi(this.http, this.storage);

  Future<Either<String, User>> getProfile() async {
    Uri url = Uri.parse("$BASEURL/profile");
    final token = await storage.read("token");

    Map<String, String> header = {"Authorization": "Bearer $token"};

    Response response = await http.get(url, headers: header);
    if (response.statusCode == 200) {
      final User userData = User.fromJson(jsonDecode(response.body)['data']);
      return Right(userData);
    }
    return const Left("Gagal Get data User");
  }

  Future<Either<String, bool>> updateProfile({
    String? name,
    String? email,
    String? phone,
  }) async {
    Uri url = Uri.parse("$BASEURL/update/profile");
    final token = await storage.read("token");

    Map<String, String> header = {"Authorization": "Bearer $token"};

    Map data = {"name": name, "email": email, "phone_number": phone};
    Response response = await http.post(url, body: data, headers: header);
    if (response.statusCode == 200) {
      return const Right(true);
    }else{
      return const Left("Gagal memperbaharui profil");
    }
  }

  Future updatePhotoProfile(File image) async {
    Uri url = Uri.parse("$BASEURL/update/foto-profile");
    final token = await storage.read("token");

    Map<String, String> header = {"Authorization": "Bearer $token"};

    final request = httpp.MultipartRequest("POST", url);
    request.headers.addAll(header);
    request.files.add(
      httpp.MultipartFile(
          "image", image.readAsBytes().asStream(), image.lengthSync(),
          filename: image.path.split('/').last),
    );

    await request.send();
    return true;
  }

  Future<Either<String, UserAddress>> getUserAddress() async {
    Uri url = Uri.parse("$BASEURL/address");
    final token = await storage.read("token");

    Map<String, String> header = {"Authorization": "Bearer $token"};

    Response response = await http.get(url, headers: header);
    if (response.statusCode == 200) {
      final UserAddress userData =
          UserAddress.fromJson(jsonDecode(response.body)['data']);
      return Right(userData);
    }
    return const Left("Gagal Get data User");
  }
}
