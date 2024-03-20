
import 'package:admin_hanaang/models/unit.dart';

class UnitState {
  final List<UnitModel>? data;
  final String? error;
  final bool isLoading;

  UnitState({this.data, required this.isLoading, this.error});

  factory UnitState.finished({List<UnitModel>? data}) {
    return UnitState(data: data, isLoading: false);
  }

  factory UnitState.noState() {
    return UnitState(isLoading: false);
  }

  factory UnitState.loading() {
    return UnitState(isLoading: true);
  }
  factory UnitState.error(String error) {
    return UnitState(isLoading: false, error: error);
  }
}
