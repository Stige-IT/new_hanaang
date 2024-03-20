import 'package:admin_hanaang/features/address/provider/address_provider.dart';
import 'package:admin_hanaang/features/user/provider/user_provider.dart';
import 'package:admin_hanaang/views/components/appbar.dart';
import 'package:admin_hanaang/views/components/dropdown_container.dart';
import 'package:admin_hanaang/views/components/form_input.dart';
import 'package:admin_hanaang/views/components/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditAddressScreen extends ConsumerStatefulWidget {
  const EditAddressScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditAddressScreenState();
}

class _EditAddressScreenState extends ConsumerState<EditAddressScreen> {
  late TextEditingController _addressDetailCtrl;

  @override
  void initState() {
    _addressDetailCtrl = TextEditingController();
    Future.microtask(() async {
      ref.watch(provinceNotifier.notifier).getAddress();
      await ref.watch(userNotifierProvider.notifier).getProfile();
      final userAddress = ref.watch(userNotifierProvider).address;
      if (userAddress != null) {
        ref.watch(idProvinceProvider.notifier).state = userAddress.province?.id;

        /// REGENCY
        ref.watch(idRegencyProvider.notifier).state = userAddress.regency?.id;
        ref
            .watch(regencyNotifier.notifier)
            .getAddress(userAddress.province!.id!);

        ///DISTRICT
        ref.watch(idDistrictProvider.notifier).state = userAddress.district?.id;
        ref
            .watch(districtNotifier.notifier)
            .getAddress(userAddress.regency!.id!);

        ///VILLAGE
        ref.watch(idVillageProvider.notifier).state = userAddress.village?.id;
        ref
            .watch(villagetNotifier.notifier)
            .getAddress(userAddress.district!.id!);

        ///DETAIL ADDRESS
        _addressDetailCtrl.text = userAddress.detail!;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _addressDetailCtrl.dispose();
    ref.invalidate(idProvinceProvider);
    ref.invalidate(provinceNotifier);
    ref.invalidate(idRegencyProvider);
    ref.invalidate(regencyNotifier);
    ref.invalidate(idDistrictProvider);
    ref.invalidate(districtNotifier);
    ref.invalidate(idVillageProvider);
    ref.invalidate(villagetNotifier);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userNotifierProvider).isLoading;
    final province = ref.watch(provinceNotifier).data;
    final regency = ref.watch(regencyNotifier).data;
    final district = ref.watch(districtNotifier).data;
    final village = ref.watch(villagetNotifier).data;
    final state = ref.watch(updateAddressNotifier);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            const AppBarSliver(title: "Edit Alamat"),
            SliverList(
                delegate: SliverChildListDelegate([
              isLoading ?
                  const Center(child: CircularProgressIndicator())
                  : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownContainer(
                      title: "Provinsi",
                      value: ref.watch(idProvinceProvider),
                      items: (province ?? [])
                          .map(
                            (e) => DropdownMenuItem(
                              value: e.id,
                              child: Text(e.name),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        ref.watch(idProvinceProvider.notifier).state =
                            value;

                        ref.invalidate(idRegencyProvider);
                        ref.invalidate(regencyNotifier);

                        ref.invalidate(idDistrictProvider);
                        ref.invalidate(districtNotifier);

                        ref.invalidate(idVillageProvider);
                        ref.invalidate(villagetNotifier);

                        ref
                            .watch(regencyNotifier.notifier)
                            .getAddress(value!);
                      },
                    ),
                    DropdownContainer(
                      title: "Kabupaten",
                      value: ref.watch(idRegencyProvider),
                      items: (regency ?? [])
                          .map(
                            (e) => DropdownMenuItem(
                              value: e.id,
                              child: Text(e.name),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        ref.watch(idRegencyProvider.notifier).state = value;

                        ref.invalidate(idDistrictProvider);
                        ref.invalidate(districtNotifier);

                        ref.invalidate(idVillageProvider);
                        ref.invalidate(villagetNotifier);
                        ref
                            .watch(districtNotifier.notifier)
                            .getAddress(value!);
                      },
                    ),
                    DropdownContainer(
                      title: "Kecamatan",
                      value: ref.watch(idDistrictProvider),
                      items: (district ?? [])
                          .map(
                            (e) => DropdownMenuItem(
                              value: e.id,
                              child: Text(e.name),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        ref.watch(idDistrictProvider.notifier).state =
                            value;
                        ref.invalidate(idVillageProvider);
                        ref.invalidate(villagetNotifier);

                        ref
                            .watch(villagetNotifier.notifier)
                            .getAddress(value!);
                      },
                    ),
                    DropdownContainer(
                      title: "Kelurahan",
                      value: ref.watch(idVillageProvider),
                      items: (village ?? [])
                          .map(
                            (e) => DropdownMenuItem(
                              value: e.id,
                              child: Text(e.name),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        ref.watch(idVillageProvider.notifier).state = value;
                      },
                    ),
                    const SizedBox(height: 20),
                    FieldInput(
                      title: "Detail alamat",
                      hintText: "Masukkan detail alamat",
                      controller: _addressDetailCtrl,
                      textValidator: "Alamat",
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      obsecureText: false,
                      isRounded: false,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        ref
                            .watch(updateAddressNotifier.notifier)
                            .updateAddress(
                              idProvince:
                                  ref.watch(idProvinceProvider).toString(),
                              idRegency:
                                  ref.watch(idRegencyProvider).toString(),
                              idDistrict:
                                  ref.watch(idDistrictProvider).toString(),
                              idVillage:
                                  ref.watch(idVillageProvider).toString(),
                              details: _addressDetailCtrl.text,
                            )
                            .then((value) {
                          if (value) {
                            ref
                                .watch(userNotifierProvider.notifier)
                                .getProfile();
                            showSnackbar(
                                context, "Berhasil memperbaharui alamat");
                          } else {
                            final error =
                                ref.watch(updateAddressNotifier).error;
                            showSnackbar(context, error.toString(),
                                isWarning: true);
                          }
                        });
                      },
                      child: state.loading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : const Text("Simpan"),
                    ),
                  ],
                ),
              )
            ]))
          ],
        ),
      ),
    );
  }
}
