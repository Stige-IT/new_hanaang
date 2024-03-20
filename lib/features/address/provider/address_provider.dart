import 'package:admin_hanaang/features/address/data/address_api.dart';
import 'package:admin_hanaang/features/address/provider/address_notifier.dart';
import 'package:admin_hanaang/features/address/provider/address_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final provinceNotifier =
    StateNotifierProvider.autoDispose<ProvinceNotifier, AddressState>((ref) {
  return ProvinceNotifier(ref.watch(addressProvider));
});
final idProvinceProvider = StateProvider.autoDispose<int?>((ref) => null);

final regencyNotifier =
    StateNotifierProvider.autoDispose<RegencyNotifier, AddressState>((ref) {
  return RegencyNotifier(
      ref.watch(addressProvider), ref.watch(idProvinceProvider));
});
final idRegencyProvider = StateProvider.autoDispose<int?>((ref) => null);

final districtNotifier =
    StateNotifierProvider.autoDispose<DistrictNotifier, AddressState>((ref) {
  return DistrictNotifier(
      ref.watch(addressProvider), ref.watch(idRegencyProvider));
});
final idDistrictProvider = StateProvider.autoDispose<int?>((ref) => null);

final villagetNotifier =
    StateNotifierProvider.autoDispose<VillageNotifier, AddressState>((ref) {
  return VillageNotifier(
      ref.watch(addressProvider), ref.watch(idDistrictProvider));
});
final idVillageProvider = StateProvider.autoDispose<int?>((ref) => null);

final updateAddressNotifier =
    StateNotifierProvider.autoDispose<UpdateAddressNotifier, AddressState>(
  (ref) => UpdateAddressNotifier(
    ref.watch(addressProvider),
  ),
);
