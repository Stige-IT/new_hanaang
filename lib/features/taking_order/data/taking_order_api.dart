import 'dart:convert';

import 'package:admin_hanaang/features/http/http_provider.dart';
import 'package:admin_hanaang/features/storage/provider/storage_provider.dart';
import 'package:admin_hanaang/features/storage/service/storage_service.dart';
import 'package:admin_hanaang/utils/constant/base_url.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';

import '../../../models/taking_order.dart';
import '../../../utils/helper/formatted_role.dart';

final takingOrderProvider = Provider<TakingOrderApi>((ref) {
  return TakingOrderApi(ref.watch(httpProvider), ref.watch(storageProvider));
});

class TakingOrderApi {
  final IOClient http;
  final SecureStorage storage;

  TakingOrderApi(this.http, this.storage);

  Future<Either<String, List<TakingOrder>>> getTakingOrder(String id) async {
    final typeAdmin = formattedPath(await storage.read('type_admin'));

    Uri url = Uri.parse("$BASEURL/$typeAdmin/retrieval/$id");
    final String token = await storage.read('token');
    Map<String, String> headers = {"Authorization": "Bearer $token"};

    Response response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      List result = jsonDecode(response.body)['data'];
      List<TakingOrder> data =
          result.map((e) => TakingOrder.fromJson(e)).toList();
      data.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
      return Right(data);
    } else {
      return const Left("gagal memuat taking order details");
    }
  }

  Future<Either<String, bool>> createNewTakingOrder(
    String id, {
    required String quantity,
  }) async {
    final typeAdmin = formattedPath(await storage.read('type_admin'));

    Uri url = Uri.parse("$BASEURL/$typeAdmin/retrieval/create");
    final String token = await storage.read('token');
    Map<String, String> headers = {"Authorization": "Bearer $token"};
    Map data = {"order_taking_id": id, "quantity": quantity};

    Response response = await http.post(url, body: data, headers: headers);
    if (response.statusCode == 200) {
      return const Right(true);
    } else {
      return const Left("Gagal membuat baru data pengambilan");
    }
  }
}
