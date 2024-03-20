import 'package:admin_hanaang/models/pre_order_user.dart';

class PreOrderUsersState {
  final List<PreOrderUser>? data;
  final bool isLoading;
  final String? error;

  PreOrderUsersState({this.data, required this.isLoading, this.error});

  factory PreOrderUsersState.noState() => PreOrderUsersState(isLoading: false);
  factory PreOrderUsersState.loading() => PreOrderUsersState(isLoading: true);
  factory PreOrderUsersState.error() => PreOrderUsersState(isLoading: false);

  factory PreOrderUsersState.finished(List<PreOrderUser> data) {
    return PreOrderUsersState(data: data, isLoading: false);
  }
}
