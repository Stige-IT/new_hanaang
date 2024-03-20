import 'package:admin_hanaang/features/address/data/address_api.dart';
import 'package:admin_hanaang/features/address/provider/address_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProvinceNotifier extends StateNotifier<AddressState> {
  final AddressApi addressApi;

  ProvinceNotifier(this.addressApi) : super(AddressState.noState());

  Future getAddress({int? id}) async {
    state = AddressState.loading();
    final result = await addressApi.getAddress(title: "province");
    result.fold(
      (error) => state = AddressState.error(error),
      (data) => state = AddressState.finished(data),
    );
  }
}

class RegencyNotifier extends StateNotifier<AddressState> {
  final AddressApi addressApi;
  final int? idProvince;

  RegencyNotifier(this.addressApi, this.idProvince)
      : super(AddressState.noState());

  Future getAddress(int id) async {
    final result =
        await addressApi.getAddress(title: "regency", id: idProvince);
    result.fold(
      (error) => state = AddressState.error(error),
      (data) => state = AddressState.finished(data),
    );
  }
}

class DistrictNotifier extends StateNotifier<AddressState> {
  final AddressApi addressApi;
  final int? idRegency;

  DistrictNotifier(this.addressApi, this.idRegency)
      : super(AddressState.noState());

  Future getAddress(int id) async {
    final result =
        await addressApi.getAddress(title: "district", id: idRegency);
    result.fold(
      (error) => state = AddressState.error(error),
      (data) => state = AddressState.finished(data),
    );
  }
}

class VillageNotifier extends StateNotifier<AddressState> {
  final AddressApi addressApi;
  final int? idDistrict;

  VillageNotifier(this.addressApi, this.idDistrict)
      : super(AddressState.noState());

  Future getAddress(int id) async {
    final result =
        await addressApi.getAddress(title: "village", id: idDistrict);
    result.fold(
      (error) => state = AddressState.error(error),
      (data) => state = AddressState.finished(data),
    );
  }
}

class UpdateAddressNotifier extends StateNotifier<AddressState> {
  final AddressApi _addressApi;

  UpdateAddressNotifier(this._addressApi) : super(AddressState.noState());

  Future<bool> updateAddress({
    String? idProvince,
    String? idRegency,
    String? idDistrict,
    String? idVillage,
    String? details,
  }) async {
    state = AddressState.loading();
    final result = await _addressApi.updateAddress(
      idProvince: idProvince,
      idRegency: idRegency,
      idDistrict: idDistrict,
      idVillage: idVillage,
      details: details,
    );
    return result.fold(
      (error) {
        state = AddressState.error(error);
        return false;
      },
      (status) {
        state = AddressState.noState();
        return status;
      },
    );
  }
}
