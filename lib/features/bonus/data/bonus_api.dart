import 'dart:convert';

import 'package:admin_hanaang/features/http/http_provider.dart';
import 'package:admin_hanaang/features/storage/provider/storage_provider.dart';
import 'package:admin_hanaang/features/storage/service/storage_service.dart';
import 'package:admin_hanaang/models/bonus.dart';
import 'package:admin_hanaang/utils/constant/base_url.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';

import '../../../utils/helper/formatted_role.dart';

final bonusProvider = Provider<BonusApi>((ref) {
  return BonusApi(ref.watch(httpProvider), ref.watch(storageProvider));
});

class BonusApi {
  final IOClient http;
  final SecureStorage storage;

  BonusApi(this.http, this.storage);

  Future<Either<String, List<Bonus>>> getBonus({String? title}) async {
    Uri url = Uri.parse("$BASEURL/super-admin/bonus/show/$title");
    String? token = await storage.read('token');

    Map<String, String> headers = {"Authorization": "Bearer $token"};

    Response response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      List result = jsonDecode(response.body)['data'];
      List<Bonus> data = result.map((e) => Bonus.fromJson(e)).toList();
      return Right(data);
    }
    return const Left("Gagal memuat data bonus");
  }

  Future<Either<String, int>> checkBonus(String userId, int quantity) async {
    final typeAdmin = formattedPath(await storage.read('type_admin'));

    Uri url = Uri.parse("$BASEURL/$typeAdmin/bonus/check");
    try {
      String? token = await storage.read('token');

      Map<String, String> headers = {"Authorization": "Bearer $token"};
      Map data = {'user_id': userId, "quantity": quantity.toString()};

      Response response = await http.post(url, body: data, headers: headers);

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body)['data'];
        int bonus = result is int ? result : int.parse(result);
        return Right(bonus);
      } else {
        return const Left("Tidak ada Bonus");
      }
    } catch (e) {
      return Left("Error $e");
    }
  }

  Future<Either<String, bool>> createBonus({
    required String bonusType,
    required String minimumOrder,
    required String numberOfBonus,
  }) async {
    Uri url = Uri.parse("$BASEURL/super-admin/bonus/create");
    String? token = await storage.read('token');
    Map<String, String> headers = {"Authorization": "Bearer $token"};
    Map data = {
      "bonus_type": bonusType,
      "minimum_order": minimumOrder,
      "number_of_bonus": numberOfBonus,
    };
    Response response = await http.post(url, body: data, headers: headers);

    if (response.statusCode == 200) {
      return const Right(true);
    }
    return const Left("Gagal membuat data bonus");
  }

  Future<Either<String, bool>> updateBonusById(
    String id, {
    required String bonusType,
    required String minimumOrder,
    required String numberOfBonus,
  }) async {
    Uri url = Uri.parse("$BASEURL/super-admin/bonus/update/$id");
    try {
      String? token = await storage.read('token');
      Map<String, String> headers = {"Authorization": "Bearer $token"};
      Map data = {
        "bonus_type_id": bonusType,
        "minimum_order": minimumOrder,
        "number_of_bonus": numberOfBonus,
      };
      Response response = await http.post(url, body: data, headers: headers);

      if (response.statusCode == 200) {
        return const Right(true);
      } else {
        return const Right(false);
      }
    } catch (e) {
      return Left("Error $e");
    }
  }

  Future<Either<String, bool>> deleteBonus(String id) async {
    Uri url = Uri.parse("$BASEURL/super-admin/bonus/delete/$id");
    String? token = await storage.read('token');
    Map<String, String> headers = {"Authorization": "Bearer $token"};
    Response response = await http.delete(url, headers: headers);

    if (response.statusCode == 200) {
      return const Right(true);
    } else {
      return const Left("Gagal menghapus bonus");
    }
  }
}
