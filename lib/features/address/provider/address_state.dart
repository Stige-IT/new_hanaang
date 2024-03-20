import 'package:admin_hanaang/models/address.dart';

class AddressState {
  final String? error;
  final bool loading;
  final List<Address>? data;

  AddressState({required this.loading, this.error, this.data});

  factory AddressState.noState() {
    return AddressState(loading: false);
  }

  factory AddressState.loading() {
    return AddressState(loading: true);
  }

  factory AddressState.error(String error) {
    return AddressState(error: error, loading: false);
  }

  factory AddressState.finished(List<Address> data) {
    return AddressState(data: data, loading: false);
  }
}
