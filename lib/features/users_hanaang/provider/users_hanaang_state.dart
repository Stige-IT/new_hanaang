import 'package:admin_hanaang/models/users_hanaang.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'users_hanaang_state.freezed.dart';

@freezed
class UserState with _$UserState {
  const factory UserState({
    @Default(true) bool isLoading,
    @Default(false) bool isLoadMoreError,
    @Default(false) bool isLoadingMore,
    @Default(1) int page,
    int? totalPage,
    List<UsersHanaang>? data,
    String? errorMessage,
    @Default(0) int totalAgen,
    @Default(0) int totalDistributor,
    @Default(0) int totalWarga,
    @Default(0) int totalKeluarga,
    @Default(0) int totalPengguna,
  }) = _UserState;
}

class UserHanaangState<T> {
  final T? data;
  int? total;
  final bool isLoading;
  final String? error;

  UserHanaangState(
      {this.data, required this.isLoading, this.error, this.total});

  factory UserHanaangState.noState() => UserHanaangState(isLoading: false);
  factory UserHanaangState.loading() => UserHanaangState(isLoading: true);

  factory UserHanaangState.finished(T data) {
    return UserHanaangState(data: data, isLoading: false);
  }
  factory UserHanaangState.error(String msg) {
    return UserHanaangState(error: msg, isLoading: false);
  }
}
