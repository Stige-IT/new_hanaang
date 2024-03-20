import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

@freezed
class BaseState<T> with _$BaseState<T> {
  const factory BaseState({
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingMore,
    String? error,
    T? data,
    @Default(1) int page,
    @Default(1) int lastPage,
    @Default(0) int? total,
  }) = _BaseState;

  factory BaseState.noState() => const BaseState();
  factory BaseState.loading() => const BaseState(isLoading: true);
  factory BaseState.error(String error) => BaseState(error: error);
  factory BaseState.finished(T data, {int? total, int? page, int? lastPage}) {
    return BaseState(
      data: data,
      total: total,
      page: page ?? 1,
      lastPage: lastPage ?? 1,
    );
  }
}

class States<T> {
  final T? data;
  final int? total;
  final String? error;
  final bool isLoading;

  States({
    this.data,
    this.total = 0,
    required this.isLoading,
    this.error,
  });

  factory States.finished(T? data, {int? total}) {
    return States(data: data, total: total, isLoading: false);
  }

  factory States.noState() => States(isLoading: false);

  factory States.loading() => States(isLoading: true);

  factory States.error(String error) => States(isLoading: false, error: error);
}
