

import 'package:admin_hanaang/models/employee.dart';

class EmployeeState {
  final List<Employee>? data;
  final String? error;
  final bool isLoading;

  EmployeeState({this.data, required this.isLoading, this.error});

  factory EmployeeState.finished(List<Employee> data) {
    return EmployeeState(data: data, isLoading: false);
  }

  factory EmployeeState.noState() {
    return EmployeeState(isLoading: false);
  }

  factory EmployeeState.loading() {
    return EmployeeState(isLoading: true);
  }
  factory EmployeeState.error(String error) {
    return EmployeeState(isLoading: false, error: error);
  }
}
