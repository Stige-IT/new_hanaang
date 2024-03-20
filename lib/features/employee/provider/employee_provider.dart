import 'package:admin_hanaang/features/employee/data/employee_api.dart';
import 'package:admin_hanaang/features/employee/provider/employee_notifier.dart';
import 'package:admin_hanaang/features/employee/provider/employee_state.dart';
import 'package:admin_hanaang/features/state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final employeesNotifier =
    StateNotifierProvider.autoDispose<EmployeeNotifier, EmployeeState>((ref) {
  return EmployeeNotifier(ref.watch(employeeProvider));
});

final createEmployeeNotifier =
    StateNotifierProvider.autoDispose<CreateEmployeeNotifier, States>((ref) {
  return CreateEmployeeNotifier(ref.watch(employeeProvider), ref);
});

final updateEmployeeNotifier =
    StateNotifierProvider.autoDispose<UpdateEmployeeNotifier, States>((ref) {
  return UpdateEmployeeNotifier(ref.watch(employeeProvider), ref);
});

final employeeNotifier =
    StateNotifierProvider.autoDispose<EmployeeByIdNotifier, EmployeeState>(
        (ref) {
  return EmployeeByIdNotifier(ref.watch(employeeProvider));
});
