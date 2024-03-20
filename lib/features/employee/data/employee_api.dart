import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:admin_hanaang/models/employee.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as httpp;
import 'package:http/io_client.dart';

import '../../../utils/constant/base_url.dart';
import '../../http/http_provider.dart';
import '../../storage/provider/storage_provider.dart';
import '../../storage/service/storage_service.dart';

final employeeProvider = Provider<EmployeeApi>((ref) {
  return EmployeeApi(ref.watch(httpProvider), ref.watch(storageProvider));
});

class EmployeeApi {
  final IOClient http;
  final SecureStorage storage;

  EmployeeApi(this.http, this.storage);

  Future<Either<String, List<Employee>>> getEmployees(
      {String? positionId}) async {
    positionId ??= '';
    final role =  await storage.getRoleName();
    Uri url = Uri.parse("$BASEURL/$role/employe?position_id=$positionId");

    final token = await storage.read("token");
    Map<String, String> header = {"Authorization": "Bearer $token"};

    Response response = await http.get(url, headers: header);
    if (response.statusCode == 200) {
      List result = jsonDecode(response.body)['data'];
      List<Employee> data = result.map((e) => Employee.fromJson(e)).toList();
      return Right(data);
    } else {
      return const Left("gagal mengambil data Employee");
    }
  }

  Future<Either<String, Employee>> getEmployee(Employee employee) async {
    final role =  await storage.getRoleName();
    Uri url = Uri.parse("$BASEURL/$role/employe/show/${employee.id}");
    final token = await storage.read("token");
    Map<String, String> header = {"Authorization": "Bearer $token"};

    Response response = await http.get(url, headers: header);

    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body)['data'];
      final data = Employee.fromJson(result);
      return Right(data);
    } else {
      return const Left("gagal mengambil data Employee");
    }
  }

  Future<Either<String, bool>> createNewEmployee(
    String positionId, {
    required String name,
    required String phoneNumber,
    File? image,
  }) async {
    final role =  await storage.getRoleName();
    Uri url = Uri.parse("$BASEURL/$role/employe/create");
    final token = await storage.read("token");
    Map<String, String> header = {"Authorization": "Bearer $token"};

    final request = httpp.MultipartRequest("POST", url);
    request.headers.addAll(header);
    request.fields['position_id'] = positionId;
    request.fields['name'] = name;
    request.fields['phone_number'] = phoneNumber;
    if (image != null) {
      request.files.add(
        httpp.MultipartFile(
          "image",
          image.readAsBytes().asStream(),
          image.lengthSync(),
          filename: image.path.split('/').last,
        ),
      );
    }
    final response = await request.send();

    if (response.statusCode == 200) {
      return const Right(true);
    } else {
      return const Left("gagal menambahkan data Employee");
    }
  }

  Future<Either<String, bool>> updateEmployee(
    String employeeId,
    String positionId, {
    required String name,
    required String phoneNumber,
    File? image,
  }) async {
    final role =  await storage.getRoleName();
    Uri url = Uri.parse("$BASEURL/$role/employe/update/$employeeId");
    final token = await storage.read("token");
    Map<String, String> header = {"Authorization": "Bearer $token"};

    final request = httpp.MultipartRequest("POST", url);
    request.headers.addAll(header);
    request.fields['position_id'] = positionId;
    request.fields['name'] = name;
    request.fields['phone_number'] = phoneNumber;
    if (image != null) {
      request.files.add(
        httpp.MultipartFile(
          "image",
          image.readAsBytes().asStream(),
          image.lengthSync(),
          filename: image.path.split('/').last,
        ),
      );
    }
    final response = await request.send();
    log(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      return const Right(true);
    } else {
      return const Left("gagal menambahkan data Employee");
    }
  }

  Future<Either<String, bool>> deleteEmployee(Employee employee) async {
    final role =  await storage.getRoleName();
    Uri url = Uri.parse("$BASEURL/$role/employe/delete/${employee.id}");
    final token = await storage.read("token");
    Map<String, String> header = {"Authorization": "Bearer $token"};

    Response response = await http.delete(url, headers: header);

    if (response.statusCode == 200) {
      return const Right(true);
    } else {
      return const Left("gagal mengambil data Employee");
    }
  }
}
