import 'dart:convert';
import 'dart:developer';

import 'package:admin_hanaang/config/constant/constant.dart';
import 'package:admin_hanaang/features/http/http_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/io_client.dart';

final fcmNotificationProvider =
    Provider<FcmApi>((ref) => FcmApi(ref.watch(httpProvider)));

class FcmApi {
  final IOClient http;

  FcmApi(this.http);

  Future<void> sendNotificationToUser(
      {required String title, required String body}) async {
    Uri url = Uri.parse("https://fcm.googleapis.com/fcm/send");

    Map data = {
      "to": "/topics/users",
      "notification": {
        "title": title,
        "body": body,
        "notification_priority": "PRIORITY_MAX",
        "icon": "@drawable/hanaang",
        "color": "#FFEB3B",
        "visibility": "PUBLIC",
      }
    };
    Map<String, String> header = {
      "Content-Type": "application/json",
      "Authorization": "key=$tokenFCM",
    };
    final response =
        await http.post(url, body: jsonEncode(data), headers: header);

    if (response.statusCode != 200) {
      log(response.body);
      throw Exception(response.body);
    }
  }

  Future<void> sendNotificationToSpesificUser(String idUser,
      {required String title, required String body, String? type}) async {
    Uri url = Uri.parse("https://fcm.googleapis.com/fcm/send");

    Map data = {
      "to": "/topics/$idUser",
      "notification": {
        "title": title,
        "body": body,
        "notification_priority": "PRIORITY_MAX",
        "icon": "@drawable/hanaang",
        "color": "#FFEB3B",
        "visibility": "PUBLIC"
      },
      "data": {
        "type": type,
      }
    };
    Map<String, String> header = {
      "Content-Type": "application/json",
      "Authorization": "key=$tokenFCM",
    };
    final response =
        await http.post(url, body: jsonEncode(data), headers: header);

    if (response.statusCode != 200) {
      log(response.body);
      throw Exception(response.body);
    }
  }
}
