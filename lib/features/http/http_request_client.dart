import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

import '../storage/provider/storage_provider.dart';
import '../storage/service/storage_service.dart';
import 'http_provider.dart';

final httpRequestProvider = Provider<HttpRequestClient>((ref) {
  return HttpRequestClient(ref.watch(httpProvider), ref.watch(storageProvider));
});

class HttpRequestClient {
  final Client _client;
  final SecureStorage storage;

  HttpRequestClient(this._client, this.storage);

  Future<Either<String, dynamic>> get(String url) async {
    final token = await storage.read("token");
    final response = await _client
        .get(Uri.parse(url), headers: {"Authorization": "Bearer $token"});
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      return right(result);
    } else {
      return left("gagal memuat data");
    }
  }

  Future<Either<String, Response>> post(String url, {Object? body}) async {
    final token = await storage.read("token");
    final headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };
    final response = await _client.post(
      Uri.parse(url),
      body: jsonEncode(body),
      headers: headers,
    );
    if (response.statusCode < 299) {
      return right(response);
    } else if (response.statusCode < 499) {
      Map<String, dynamic> message = jsonDecode(response.body);
      if (message.isEmpty) {
        return left("Gagal membuat data");
      }
      List<String> keys = message.keys.toList();
      log(message.toString());
      log(keys[0]);
      String responseMessage = message[keys[0]][0];
      log(responseMessage);
      return left(responseMessage);
    } else {
      return left("Gagal membuat data");
    }
  }

  // put
  Future<Either<String, bool>> put(String url,
      {Map<String, dynamic>? data}) async {
    final token = await storage.read("token");
    final response = await _client.put(
      Uri.parse(url),
      body: jsonEncode(data),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      return right(true);
    } else {
      return left("gagal memperbaharui data");
    }
  }

  // multipart post / put
  Future<Either<String, bool>> multipart(
    String method,
    String url, {
    Map<String, String>? data,
    File? file,
    String? fieldFile,
  }) async {
    final token = await storage.read("token");
    final request = MultipartRequest(method, Uri.parse(url));
    request.headers.addAll({"Authorization": "Bearer $token"});
    if (data != null) {
      request.fields.addAll(data);
    }
    if (file != null) {
      final multipartFile = MultipartFile.fromBytes(
        fieldFile!,
        file.readAsBytesSync(),
        filename: file.path.split("/").last,
      );
      request.files.add(multipartFile);
    }
    final response = await request.send();
    final responseString = await response.stream.bytesToString();
    if (kDebugMode) {
      print(responseString);
    }
    if (response.statusCode < 299) {
      return right(true);
    } else if (response.statusCode < 499) {
      Map<String, dynamic> message = jsonDecode(responseString);
      if (message.isEmpty) {
        return left("Gagal membuat data");
      }
      if(message['message'] != null){
        return left(message['message']);
      }
      List<String> keys = message.keys.toList();
      log(message.toString());
      log(keys[0]);
      String responseMessage = message[keys[0]][0];
      log(responseMessage);
      return left(responseMessage);
    } else {
      return left("Gagal membuat data");
    }

  }

  // delete
  Future<Either<String, bool>> delete(String url) async {
    final token = await storage.read("token");
    final response = await _client
        .delete(Uri.parse(url), headers: {"Authorization": "Bearer $token"});
    if (response.statusCode == 200) {
      return right(true);
    } else if (response.statusCode == 401) {
      return left(jsonDecode(response.body)['message']);
    } else {
      return left("gagal menghapus data");
    }
  }
}
