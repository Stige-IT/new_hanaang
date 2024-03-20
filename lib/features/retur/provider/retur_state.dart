import 'package:admin_hanaang/models/retur.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'retur_state.freezed.dart';

@freezed
class ReturStates with _$ReturStates {
  const factory ReturStates({
    @Default(true) bool isLoading,
    @Default(false) bool isLoadingMore,
    String? error,
    @Default(1) int page,
    int? totalPage,
    List<Retur>? data,
  }) = _ReturStates;
}

class ReturState {
  final List<Retur>? data;

  final String? error;
  bool isLoading;

  ReturState({this.data, required this.isLoading, this.error});

  factory ReturState.finished({List<Retur>? data}) {
    return ReturState(data: data ?? [], isLoading: false);
  }

  factory ReturState.noState() {
    return ReturState(isLoading: false);
  }

  factory ReturState.loading() {
    return ReturState(isLoading: true);
  }
  factory ReturState.error(String error) {
    return ReturState(isLoading: false, error: error);
  }
}
