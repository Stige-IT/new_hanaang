import 'dart:convert';

import 'package:admin_hanaang/features/http/http_provider.dart';
import 'package:admin_hanaang/features/storage/provider/storage_provider.dart';
import 'package:admin_hanaang/features/storage/service/storage_service.dart';
import 'package:admin_hanaang/models/address.dart';
import 'package:admin_hanaang/utils/constant/base_url.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';

final addressProvider = Provider<AddressApi>((ref) {
  return AddressApi(ref.watch(httpProvider), ref.watch(storageProvider));
});

class AddressApi {
  final IOClient http;
  final SecureStorage storage;

  AddressApi(this.http, this.storage);

  Future<Either<String, List<Address>>> getAddress({
    int? id,
    String? title,
  }) async {

    Uri url = Uri.parse("$BASEURL/$title");
    if (title != 'province') {
      url = Uri.parse("$BASEURL/$title/$id");
    }

    final token = await storage.read("token");
    Map<String, String> header = {"Authorization": "Bearer $token"};

    Response response = await http.get(url, headers: header);

    if (response.statusCode == 200) {
      List result = jsonDecode(response.body)['data'];
      List<Address> addresses = result.map((e) => Address.fromJson(e)).toList();
      // addresses.insert(0, Address(id: 0, name: "Silahkan Pilih"));
      return Right(addresses);
    } else {
      return const Left("Data Tidak di temukan");
    }
  }

  Future<Either<String,bool>> updateAddress({
    String? idProvince,
    String? idRegency,
    String? idDistrict,
    String? idVillage,
    String? details,
  }) async {
    Uri url = Uri.parse("$BASEURL/update/address");

    final token = await storage.read("token");

    Map data = {
      "province_id": idProvince,
      "regency_id": idRegency,
      "district_id": idDistrict,
      "village_id": idVillage,
      "detail": details,
    };
    Map<String, String> header = {"Authorization": "Bearer $token"};

    Response response = await http.post(url, body: data, headers: header);

    if (response.statusCode == 200) {
      return const Right(true);
    } else {
      return const Left("Gagal memperbaharui Alamat");
    }
  }
}
