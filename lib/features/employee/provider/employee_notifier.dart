import 'dart:io';

import 'package:admin_hanaang/features/employee/data/employee_api.dart';
import 'package:admin_hanaang/features/employee/provider/employee_provider.dart';
import 'package:admin_hanaang/features/employee/provider/employee_state.dart';
import 'package:admin_hanaang/features/state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/employee.dart';
import '../../../utils/helper/failure_exception.dart';

class EmployeeNotifier extends StateNotifier<EmployeeState> {
  EmployeeNotifier(this.api) : super(EmployeeState.noState());

  final EmployeeApi api;

  Future getEmployee({String? positionId}) async {
    state = EmployeeState.loading();
    final result = await api.getEmployees(positionId: positionId);
    result.fold(
      (l) => state = EmployeeState.error(l),
      (r) => state = EmployeeState.finished(r),
    );
  }

  Future<dynamic> deleteEmployee({Employee? employee}) async {
    final result = await api.deleteEmployee(employee!);
    final status = result.fold((l) => false, (r) {
      getEmployee();
      return true;
    });
    return status;
  }
}

class CreateEmployeeNotifier extends StateNotifier<States> {
  final EmployeeApi _employeeApi;
  final Ref ref;
  CreateEmployeeNotifier(this._employeeApi, this.ref) : super(States.noState());

  Future<bool> createNew(
    String positionId, {
    required String name,
    required String phoneNumber,
    File? image,
  }) async {
    state = States.loading();
    try {
      final result = await _employeeApi.createNewEmployee(positionId,
          name: name, phoneNumber: phoneNumber, image: image);
      state = result.fold(
        (error) =>  States.error(error),
        (success) {
          ref.read(employeesNotifier.notifier).getEmployee();
          return States.noState();
        },
      );
      return result.isRight();
    }catch(e){
      state = States.error(exceptionTomessage(e));
      return false;
    }
  }
}

class UpdateEmployeeNotifier extends StateNotifier<States> {
  final EmployeeApi _employeeApi;
  final Ref ref;
  UpdateEmployeeNotifier(this._employeeApi, this.ref) : super(States.noState());

  Future<bool> update(
    String employeeId,
    String positionId, {
    required String name,
    required String phoneNumber,
    File? image,
  }) async {
    state = States.loading();
    try {
      final result = await _employeeApi.updateEmployee(
        employeeId,
        positionId,
        name: name,
        phoneNumber: phoneNumber,
      );
      state = result.fold(
        (error) => States.error(error),
        (success) {
          ref.read(employeesNotifier.notifier).getEmployee();
          return States.noState();
        },
      );
      return result.isRight();
    }catch(e){
      state = States.error(exceptionTomessage(e));
      return false;
    }
  }
}

class EmployeeByIdNotifier extends StateNotifier<EmployeeState> {
  EmployeeByIdNotifier(this.api) : super(EmployeeState.noState());

  final EmployeeApi api;

  Future getEmployee(Employee employee) async {
    state = EmployeeState.loading();
    final result = await api.getEmployee(employee);
    result.fold(
      (l) => state = EmployeeState.error(l),
      (r) => state = EmployeeState.finished([r]),
    );
  }
}
