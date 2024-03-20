import 'dart:convert';

import 'package:admin_hanaang/features/http/http_request_client.dart';
import 'package:admin_hanaang/features/storage/provider/storage_provider.dart';
import 'package:admin_hanaang/models/detail_hutang.dart';
import 'package:admin_hanaang/models/hutang.dart';
import 'package:admin_hanaang/utils/constant/base_url.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../storage/service/storage_service.dart';

final hutangProvider = Provider<HutangApi>((ref) {
  return HutangApi(
    ref.watch(httpRequestProvider),
    ref.watch(storageProvider),
  );
});

class HutangApi {
  final HttpRequestClient _http;
  final SecureStorage _storage;

  HutangApi(this._http,this._storage);

  Future<Either<String, List<Hutang>>> getHutang() async {
    final role = await _storage.getRoleName();
    final url = "$BASEURL/$role/hutang";
    final response = await _http.get(url);
    return response.fold(
      (error) => Left(error),
      (response) {
        final data = jsonDecode(response.body);
        final hutang = data.map<Hutang>((e) => Hutang.fromJson(e)).toList();
        return Right(hutang);
      },
    );
  }

  Future<Either<String, int>> getTotalHutang() async {
    final role = await _storage.getRoleName();
    final url = "$BASEURL/$role/hutang/total";
    final response = await _http.get(url);
    return response.fold(
      (error) => Left(error),
      (response) {
        final data = jsonDecode(response.body);
        final total = data['total'];
        return Right(total);
      },
    );
  }

  Future<Either<String, List<DetailHutang>>> getDetailHutang(
      String hutangId) async {
    final role = await _storage.getRoleName();
    final url = "$BASEURL/$role/hutang/$hutangId";
    final response = await _http.get(url);
    return response.fold(
      (error) => Left(error),
      (response) {
        final data = jsonDecode(response.body);
        final detailHutang =
            data.map<DetailHutang>((e) => DetailHutang.fromJson(e)).toList();
        return Right(detailHutang);
      },
    );
  }
}
