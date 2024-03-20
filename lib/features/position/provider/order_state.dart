import 'package:admin_hanaang/models/position.dart';

class PositionState {
  final List<Position>? data;
  final String? error;
  final bool isLoading;

  PositionState({this.data, required this.isLoading, this.error});

  factory PositionState.finished(List<Position> data) {
    return PositionState(data: data, isLoading: false);
  }

  factory PositionState.noState() {
    return PositionState(isLoading: false);
  }

  factory PositionState.loading() {
    return PositionState(isLoading: true);
  }
  factory PositionState.error(String error) {
    return PositionState(isLoading: false, error: error);
  }
}
