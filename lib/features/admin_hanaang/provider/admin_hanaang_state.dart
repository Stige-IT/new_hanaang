import 'package:admin_hanaang/models/admin_hanaang.dart';

class AdminHanaangState {
  final List<AdminHanaang>? data;
  final bool? isLoading;
  final String? error;

  AdminHanaangState({this.data, this.isLoading, this.error});

  factory AdminHanaangState.noState() => AdminHanaangState(isLoading: false);
  factory AdminHanaangState.loading() => AdminHanaangState(isLoading: true);

  factory AdminHanaangState.finished(List<AdminHanaang> data) {
    return AdminHanaangState(data: data, isLoading: false);
  }
}
