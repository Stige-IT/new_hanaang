import 'dart:convert';

import 'package:admin_hanaang/features/http/http_provider.dart';
import 'package:admin_hanaang/features/storage/provider/storage_provider.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';

import '../../../models/position.dart';
import '../../../utils/constant/base_url.dart';
import '../../storage/service/storage_service.dart';

final positionProvider = Provider<PositionApi>((ref) {
  return PositionApi(ref.watch(httpProvider), ref.watch(storageProvider));
});

class PositionApi {
  final IOClient http;
  final SecureStorage storage;

  PositionApi(this.http, this.storage);

  Future<Either<String, List<Position>>> getPostions() async {
    final role =  await storage.getRoleName();
    Uri url = Uri.parse("$BASEURL/$role/position");
    final token = await storage.read("token");
    Map<String, String> header = {"Authorization": "Bearer $token"};

    Response response = await http.get(url, headers: header);

    if (response.statusCode == 200) {
      List result = jsonDecode(response.body)['data'];
      List<Position> data = result.map((e) => Position.fromJson(e)).toList();
      return Right(data);
    } else {
      return const Left("gagal mengambil data position");
    }
  }

  Future<Either<String, Position>> getPostion(String positionId) async {
    final role =  await storage.getRoleName();
    Uri url = Uri.parse("$BASEURL/$role/position/show/$positionId");
    final token = await storage.read("token");
    Map<String, String> header = {"Authorization": "Bearer $token"};

    Response response = await http.get(url, headers: header);

    if (response.statusCode == 200) {
      Position data = Position.fromJson(jsonDecode(response.body)['data']);
      return Right(data);
    } else {
      return const Left("gagal mengambil data position");
    }
  }

  Future<Either<String, bool>> createPosition({required String name}) async {
    final role =  await storage.getRoleName();
    Uri url = Uri.parse("$BASEURL/$role/position/create");
    final token = await storage.read("token");
    Map<String, String> header = {"Authorization": "Bearer $token"};
    Map data = {"name": name};

    Response response = await http.post(url, body: data, headers: header);

    if (response.statusCode == 200) {
      return const Right(true);
    } else {
      return const Left("gagal mengambil data position");
    }
  }

  Future<Either<String, bool>> updatePosition(String positionId,
      {required String name}) async {
    final role =  await storage.getRoleName();
    Uri url = Uri.parse("$BASEURL/$role/position/update/$positionId");
    final token = await storage.read("token");
    Map<String, String> header = {"Authorization": "Bearer $token"};
    Map data = {"name": name};

    Response response = await http.post(url, body: data, headers: header);

    if (response.statusCode == 200) {
      return const Right(true);
    } else {
      return const Left("gagal memperbaharui data position");
    }
  }

  Future<Either<String, bool>> deletePosition(String positionId) async {
    final role =  await storage.getRoleName();
    Uri url = Uri.parse("$BASEURL/$role/position/delete/$positionId");
    final token = await storage.read("token");
    Map<String, String> header = {"Authorization": "Bearer $token"};

    Response response = await http.delete(url, headers: header);

    if (response.statusCode == 200 || response.statusCode == 500) {
      return const Right(true);
    } else {
      return const Left("gagal menghapus data position");
    }
  }
}
