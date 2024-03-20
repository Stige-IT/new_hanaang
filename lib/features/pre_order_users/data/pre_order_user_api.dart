import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:admin_hanaang/features/fcm/fcm_api.dart';
import 'package:admin_hanaang/features/http/http_provider.dart';
import 'package:admin_hanaang/features/storage/provider/storage_provider.dart';
import 'package:admin_hanaang/features/storage/service/storage_service.dart';
import 'package:admin_hanaang/models/pre_order_user.dart';
import 'package:admin_hanaang/utils/constant/base_url.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as httpp;
import 'package:http/io_client.dart';

import '../../../models/response_data.dart';

final preOrderUsersProvider = Provider<PreOrderUsersApi>((ref) {
  return PreOrderUsersApi(ref.watch(httpProvider), ref.watch(storageProvider),
      ref.watch(fcmNotificationProvider));
});

class PreOrderUsersApi {
  final IOClient http;
  final SecureStorage storage;
  final FcmApi _fcmApi;

  PreOrderUsersApi(this.http, this.storage, this._fcmApi);

  Future<Either<String, ResponseData>> getPreOrderUsers() async {
    final role = await storage.getRoleName();

    Uri url = Uri.parse("$BASEURL/$role/pre-order");
    String token = await storage.read('token');

    Map<String, String> headers = {"Authorization": "Bearer $token"};
    Response response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      List result = jsonDecode(response.body)['data'];
      int currentPage = jsonDecode(response.body)['meta']['current_page'];
      int lastPage = jsonDecode(response.body)['meta']['last_page'];
      int total = jsonDecode(response.body)['meta']['total'];
      final data = result.map((e) => PreOrderUser.fromJson(e)).toList();
      return Right(ResponseData(
        data: data,
        total: total,
        currentPage: currentPage,
        lastPage: lastPage,
      ));
    } else {
      return const Left("Gagal Mengambil data pre order users");
    }
  }

  Future<Either<String, List<PreOrderUser>>> searchPreOrder(
      String query) async {
    final role = await storage.getRoleName();

    Uri url = Uri.parse("$BASEURL/$role/pre-order/search/?search=$query");
    String token = await storage.read('token');

    Map<String, String> headers = {"Authorization": "Bearer $token"};
    Response response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      List result = jsonDecode(response.body)['data'];
      List<PreOrderUser> data =
          result.map((e) => PreOrderUser.fromJson(e)).toList();
      return Right(data);
    } else {
      return const Left("Gagal mencari data pre order users");
    }
  }

  Future<Either<String, bool>> updatePreOrderUser(
    String preOrderUserId,
    String userId, {
    String? paymentMethodId,
    int? nominal,
    File? proofOfPayment,
    int? orderTaken,
  }) async {
    final role = await storage.getRoleName();
    paymentMethodId ??=
        "70d3b00c-b407-49f6-a3b2-4793e2d1b16d"; //ID METHOD HUTANG
    Uri url = Uri.parse("$BASEURL/$role/pre-order/update/$preOrderUserId");

    String token = await storage.read('token');
    Map<String, String> headers = {"Authorization": "Bearer $token"};

    final request = httpp.MultipartRequest("POST", url);
    request.headers.addAll(headers);

    request.fields["payment_method_id"] = paymentMethodId;
    request.fields["order_taken"] = (orderTaken ?? 0).toString();
    request.fields["nominal"] = (nominal ?? 0).toString();

    if (proofOfPayment != null) {
      request.files.add(httpp.MultipartFile(
        "proof_of_payment",
        proofOfPayment.readAsBytes().asStream(),
        proofOfPayment.lengthSync(),
        filename: proofOfPayment.path.split('/').last,
      ));
    }
    log(request.fields.toString());

    StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      _fcmApi.sendNotificationToSpesificUser(userId,
          title: "Pre Order Update", body: "Pre order anda diterima !");
      return const Right(true);
    } else {
      return const Left("Gagal memindahkan pre order ke pesanan");
    }
  }

  Future<Either<String, bool>> resetPreOrder() async {
    final role = await storage.getRoleName();

    Uri url = Uri.parse("$BASEURL/$role/pre-order/reset");
    String token = await storage.read('token');

    Map<String, String> headers = {"Authorization": "Bearer $token"};
    Response response = await http.post(url, headers: headers);

    if (response.statusCode == 200) {
      return const Right(true);
    } else {
      return const Left("Gagal Reset data pre order users");
    }
  }
}
