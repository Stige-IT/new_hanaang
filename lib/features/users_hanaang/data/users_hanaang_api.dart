import 'dart:convert';

import 'package:admin_hanaang/features/http/http_provider.dart';
import 'package:admin_hanaang/features/http/http_request_client.dart';
import 'package:admin_hanaang/features/storage/provider/storage_provider.dart';
import 'package:admin_hanaang/models/user_hanaang_detail.dart';
import 'package:admin_hanaang/models/users_hanaang.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';

import '../../../utils/constant/base_url.dart';
import '../../fcm/fcm_api.dart';
import '../../storage/service/storage_service.dart';

final usersHanaangProvider = Provider<UsersHanaangApi>((ref) {
  return UsersHanaangApi(
    ref.watch(httpRequestProvider),
    ref.watch(httpProvider),
    ref.watch(storageProvider),
    ref.watch(fcmNotificationProvider),
  );
});

class UsersHanaangApi {
  final HttpRequestClient _http;
  final IOClient http;
  final SecureStorage storage;
  final FcmApi _fcmApi;

  UsersHanaangApi(this._http, this.http, this.storage, this._fcmApi);

  Future<Either<String, List<UsersHanaang>>> getUserHanaang(String type) async {
    final role = await storage.getRoleName();
    Uri url = Uri.parse("$BASEURL/$role/user/?nameRole=$type");
    String token = await storage.read('token');
    Map<String, String> headers = {"Authorization": "Bearer $token"};

    Response response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      List result = jsonDecode(response.body)['data']['data'];
      List<UsersHanaang> data =
          result.map((e) => UsersHanaang.fromJson(e)).toList();
      return Right(data);
    } else {
      return Left("Gagal memuat Users $type");
    }
  }

  Future<Either<String, Map<String, dynamic>>> getUsersHanaang(String nameRole,
      {int? page}) async {
    final role = await storage.getRoleName();
    Uri url = Uri.parse("$BASEURL/$role/user?nameRole=$nameRole&page=$page");
    String token = await storage.read('token');
    Map<String, String> headers = {"Authorization": "Bearer $token"};

    Response response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      List result = jsonDecode(response.body)['data']['data'];
      int currentPage = jsonDecode(response.body)['data']['current_page'];
      int lastPage = jsonDecode(response.body)['data']['last_page'];
      int total = jsonDecode(response.body)['data']['total'];
      List<UsersHanaang> data =
          result.map((e) => UsersHanaang.fromJson(e)).toList();
      return Right({
        "data": data,
        "current_page": currentPage,
        "last_page": lastPage,
        "total": total,
      });
    } else {
      return Left("Gagal memuat Users $nameRole");
    }
  }

  Future<Either<String, List<UsersHanaang>>> searchUsersHanaang(
      String query) async {
    final role = await storage.getRoleName();
    Uri url = Uri.parse("$BASEURL/$role/user/search");
    String token = await storage.read('token');
    Map<String, String> headers = {"Authorization": "Bearer $token"};

    Response response =
        await http.post(url, body: {"search": query}, headers: headers);
    if (response.statusCode == 200) {
      List result = jsonDecode(response.body)['data']['data'];
      List<UsersHanaang> data =
          result.map((e) => UsersHanaang.fromJson(e)).toList();
      return Right(data);
    } else {
      return const Left("Gagal memuat Users");
    }
  }

  Future<Either<String, UserHanaangDetail>> getDetailUserHanaang(
      String userId) async {
    final role = await storage.getRoleName();
    Uri url = Uri.parse("$BASEURL/$role/user/$userId");
    String token = await storage.read('token');
    Map<String, String> headers = {"Authorization": "Bearer $token"};

    Response response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body)['data'];
      UserHanaangDetail data = UserHanaangDetail.fromJson(result);
      return Right(data);
    } else {
      return const Left("Gagal memuat Detail Users");
    }
  }

  Future<Either<String, bool>> createNewUserHanaang(
    String roleId, {
    required String name,
    required String email,
    required String phoneNumber,
    required String password,
    required String passwordConfirmation,
  }) async {
    final role = await storage.getRoleName();
    final url = '$BASEURL/$role/user/create';
    Map data = {
      "role_id": roleId,
      "name": name,
      "email": email,
      "phone_number": phoneNumber,
      "password": password,
      "password_confirmation": passwordConfirmation,
    };
    final response = await _http.post(url, body: data);
    return response.fold(
      (error) => Left(error),
      (success) => const Right(true),
    );
  }

  Future editUsersHanaang(String id, newRoleId) async {
    try {
      final role = await storage.getRoleName();
      Uri url = Uri.parse("$BASEURL/$role/user/update/$id");
      String token = await storage.read('token');
      Map<String, String> headers = {"Authorization": "Bearer $token"};
      Map data = {"role_id": newRoleId};
      Response response = await http.post(url, body: data, headers: headers);
      if (response.statusCode == 200) {
        _fcmApi.sendNotificationToSpesificUser(id,
            title: "Pembaharuan tipe pengguna",
            body:
                "Tipe pengguna anda sudah diperbaharui, silahkan cek dan login kembali");
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return "Error $e";
    }
  }

  Future suspendUsersHanaang(UsersHanaang user) async {
    try {
      final role = await storage.getRoleName();
      Uri url = Uri.parse("$BASEURL/$role/user/suspend/${user.id}");
      String token = await storage.read('token');
      Map<String, String> headers = {"Authorization": "Bearer $token"};
      Map data = {"suspend": user.suspend == "0" ? "1" : "0"};
      Response response = await http.post(url, body: data, headers: headers);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return "Error $e";
    }
  }

  Future removeUsersHanaang(String id) async {
    try {
      final role = await storage.getRoleName();
      Uri url = Uri.parse("$BASEURL/$role/user/delete/$id");
      String token = await storage.read('token');
      Map<String, String> headers = {"Authorization": "Bearer $token"};

      Response response = await http.post(url, headers: headers);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return "Error $e";
    }
  }
}
