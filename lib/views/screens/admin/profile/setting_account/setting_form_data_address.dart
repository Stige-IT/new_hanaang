part of "../profile.dart";
class SettingFormDataAddress extends ConsumerStatefulWidget {
  const SettingFormDataAddress({super.key});

  @override
  ConsumerState createState() => _SettingFormDataAddressState();
}

class _SettingFormDataAddressState
    extends ConsumerState<SettingFormDataAddress> {
  late TextEditingController _addressCtrl;

  @override
  void initState() {
    _addressCtrl = TextEditingController();
    Future.microtask(() {
      ref.watch(provinceNotifier.notifier).getAddress();
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
        _addressCtrl.text = userAddress.detail!;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _addressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final province = ref.watch(provinceNotifier).data;
    final regency = ref.watch(regencyNotifier).data;
    final district = ref.watch(districtNotifier).data;
    final village = ref.watch(villagetNotifier).data;
    final state = ref.watch(updateAddressNotifier);
    return Column(
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
            ref.watch(idProvinceProvider.notifier).state = value;

            ref.invalidate(idRegencyProvider);
            ref.invalidate(regencyNotifier);

            ref.invalidate(idDistrictProvider);
            ref.invalidate(districtNotifier);

            ref.invalidate(idVillageProvider);
            ref.invalidate(villagetNotifier);

            ref.watch(regencyNotifier.notifier).getAddress(value!);
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
            ref.watch(districtNotifier.notifier).getAddress(value!);
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
            ref.watch(idDistrictProvider.notifier).state = value;
            ref.invalidate(idVillageProvider);
            ref.invalidate(villagetNotifier);

            ref.watch(villagetNotifier.notifier).getAddress(value!);
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
          controller: _addressCtrl,
          textValidator: "Alamat",
          keyboardType: TextInputType.multiline,
          maxLines: 3,
          obsecureText: false,
          isRounded: false,
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: () {
              ref
                  .watch(updateAddressNotifier.notifier)
                  .updateAddress(
                    idProvince: ref.watch(idProvinceProvider).toString(),
                    idRegency: ref.watch(idRegencyProvider).toString(),
                    idDistrict: ref.watch(idDistrictProvider).toString(),
                    idVillage: ref.watch(idVillageProvider).toString(),
                    details: _addressCtrl.text,
                  )
                  .then((value) {
                if (value) {
                  ref.watch(userNotifierProvider.notifier).getProfile();
                  showSnackbar(context, "Berhasil memperbaharui alamat");
                } else {
                  final error = ref.watch(updateAddressNotifier).error;
                  showSnackbar(context, error.toString(), isWarning: true);
                }
              });
            },
            child: const Text("Simpan"),
          ),
        ),
        const SizedBox(height: 10),
        if (state.loading) const LinearProgressIndicator(),
      ],
    );
  }
}
