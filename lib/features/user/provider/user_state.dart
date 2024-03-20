import 'package:admin_hanaang/models/user.dart';
import 'package:admin_hanaang/models/user_address.dart';

class UserState {
  final User? data;
  final UserAddress? address;
  final String? error;
  final bool isLoading;

  UserState({this.data,this.address,  required this.isLoading, this.error});

  factory UserState.finished({User? user, UserAddress? address}) {
    return UserState(data: user, address: address, isLoading: false);
  }

  factory UserState.noState() {
    return UserState(isLoading: false);
  }

  factory UserState.loading() {
    return UserState(isLoading: true);
  }
  factory UserState.error(String error) {
    return UserState(isLoading: false, error: error);
  }
}
