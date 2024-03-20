import 'dart:convert';

import 'package:admin_hanaang/features/http/http_provider.dart';
import 'package:admin_hanaang/features/storage/provider/storage_provider.dart';
import 'package:admin_hanaang/models/detail_market.dart';
import 'package:admin_hanaang/models/market.dart';
import 'package:admin_hanaang/utils/constant/base_url.dart';
import 'package:admin_hanaang/utils/helper/formatted_role.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import '../../storage/service/storage_service.dart';

final marketProvider = Provider<MarketApi>((ref) {
  return MarketApi(ref.watch(httpProvider), ref.watch(storageProvider));
});

class MarketApi {
  final IOClient http;
  final SecureStorage storage;

  MarketApi(this.http, this.storage);

  Future<Either<String, Map>> getMarkets({int? page, String? idUser}) async {
    idUser ??= '';
    final typeAdmin = formattedPath(await storage.read("type_admin"));
    final token = await storage.read('token');
    Uri url = Uri.parse("$BASEURL/$typeAdmin/stall?id=$idUser&page=$page");

    Response response =
        await http.get(url, headers: {"Authorization": "Bearer $token"});
    if (response.statusCode == 200) {
      List result = jsonDecode(response.body)['data']['data'];
      List<Market> data = result.map((e) => Market.fromJson(e)).toList();

      int currentPage = jsonDecode(response.body)['data']['current_page'];
      int lastPage = jsonDecode(response.body)['data']['last_page'];
      return Right({
        "data": data,
        "current_page": currentPage,
        "last_page": lastPage,
      });
    }
    return const Left("Gagal memuat data warung");
  }

  Future<Either<String, DetailMarket>> getDetailMarket(String marketId) async {
    final typeAdmin = formattedPath(await storage.read("type_admin"));
    final token = await storage.read('token');
    Uri url = Uri.parse("$BASEURL/$typeAdmin/stall/show/$marketId");

    Response response =
        await http.get(url, headers: {"Authorization": "Bearer $token"});
    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body)['data'];
      DetailMarket data = DetailMarket.fromJson(result);
      return Right(data);
    }
    return const Left("Gagal memuat detail data warung");
  }

  Future<Either<String, List<Market>>> searchMarket(String query,
      {String? idUser}) async {
    idUser ??= '';
    final typeAdmin = formattedPath(await storage.read("type_admin"));
    final token = await storage.read('token');
    Uri url =
        Uri.parse("$BASEURL/$typeAdmin/stall/search/?search=$query&id=$idUser");

    Response response =
        await http.get(url, headers: {"Authorization": "Bearer $token"});
    if (response.statusCode == 200) {
      List result = jsonDecode(response.body)['data']['data'];
      List<Market> data = result.map((e) => Market.fromJson(e)).toList();
      return Right(data);
    }
    return const Left("Gagal mencari data warung");
  }
}
