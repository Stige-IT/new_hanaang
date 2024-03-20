import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:admin_hanaang/features/http/http_provider.dart';
import 'package:admin_hanaang/features/storage/provider/storage_provider.dart';
import 'package:admin_hanaang/features/storage/service/storage_service.dart';
import 'package:admin_hanaang/models/payment.dart';
import 'package:admin_hanaang/utils/constant/base_url.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as httpp;
import 'package:http/io_client.dart';

import '../../../utils/helper/formatted_role.dart';

final paymentProvider = Provider<PaymentApi>((ref) {
  return PaymentApi(ref.watch(httpProvider), ref.watch(storageProvider));
});

class PaymentApi {
  final IOClient http;
  final SecureStorage storage;

  PaymentApi(this.http, this.storage);

  Future<Either<String, List<Payment>>> getPayment(String id) async {
    final typeAdmin = formattedPath(await storage.read('type_admin'));

    Uri url = Uri.parse("$BASEURL/$typeAdmin/payment/$id");
    final String token = await storage.read('token');
    Map<String, String> headers = {"Authorization": "Bearer $token"};

    Response response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      List result = jsonDecode(response.body)['data'];
      List<Payment> data = result.map((e) => Payment.fromJson(e)).toList();
      data.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
      return Right(data);
    } else {
      return const Left("gagal memuat payment");
    }
  }

  Future<Either<String, bool>> createNewPayment(
    String id, {
    required String paymentMethodId,
    required String nominal,
    File? image,
  }) async {
    final typeAdmin = formattedPath(await storage.read('type_admin'));
    Uri url = Uri.parse("$BASEURL/$typeAdmin/payment/create");
    final String token = await storage.read('token');
    Map<String, String> headers = {"Authorization": "Bearer $token"};

    final request = httpp.MultipartRequest("POST", url);
    request.headers.addAll(headers);

    request.fields["order_payment_id"] = id;
    request.fields["payment_method_id"] = paymentMethodId;
    request.fields["nominal"] = nominal.replaceAll('.', '');

    if (image != null) {
      request.files.add(httpp.MultipartFile(
        "proof_of_payment",
        image.readAsBytes().asStream(),
        image.lengthSync(),
        filename: image.path.split('/').last,
      ));
    }

    StreamedResponse response = await request.send();
    log(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      return const Right(true);
    } else {
      return const Left("Gagal membuat pembayaran baru");
    }
  }
}
