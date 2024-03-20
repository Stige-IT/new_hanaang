import 'dart:convert';

import 'package:admin_hanaang/features/storage/provider/storage_provider.dart';
import 'package:admin_hanaang/features/storage/service/storage_service.dart';
import 'package:admin_hanaang/models/pre_order.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/constant/base_url.dart';
import '../../http/http_request_client.dart';

final preOrderProvider = Provider<PreOrderApi>((ref) {
  return PreOrderApi(
    ref.watch(httpRequestProvider),
    ref.watch(storageProvider),
  );
});

class PreOrderApi {
  final HttpRequestClient _http;
  final SecureStorage storage;

  PreOrderApi(this._http,this.storage);

  Future<Either<String, PreOrder>> getPreOrder() async {
    final role = await storage.getRoleName();
    final url = "$BASEURL/$role/open-pre-order";
    final response = await _http.get(url);
    return response.fold(
      (error) => Left(error),
      (response) {
        final data = response['data'];
        final preOrder = PreOrder.fromJson(data);
        return Right(preOrder);
      },
    );
  }

  Future<Either<String, String>> updatePreorder(
    DateTime start,
    DateTime end,
    String total,
  ) async {
    final role = await storage.getRoleName();
    final url = "$BASEURL/$role/open-pre-order/update";
    final body = {
      "start": start.toIso8601String(),
      "end": end.toIso8601String(),
      "stock_po": total,
    };
    final response = await _http.post(url,body: body);
    return response.fold(
      (error) => Left(error),
      (response) {
        final data = jsonDecode(response.body);
        final message = data['message'];
        return Right(message);
      },
    );
  }
}
