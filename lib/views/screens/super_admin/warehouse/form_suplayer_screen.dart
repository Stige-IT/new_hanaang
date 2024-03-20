import 'dart:io';

import 'package:admin_hanaang/config/theme.dart';
import 'package:admin_hanaang/features/image_picker/image_picker.dart';
import 'package:admin_hanaang/features/suplayer/provider/suplayer_provider.dart';
import 'package:admin_hanaang/utils/constant/base_url.dart';
import 'package:admin_hanaang/views/components/form_input.dart';
import 'package:admin_hanaang/views/components/loading_in_button.dart';
import 'package:admin_hanaang/views/components/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../features/address/provider/address_provider.dart';
import '../../../../models/suplayer.dart';
import '../../../components/dropdown_container.dart';

final imageNotifier = StateProvider.autoDispose<File?>((ref) => null);
final toggleNotifier = StateProvider.autoDispose<bool>((ref) => false);

class FormSuplayerScreen extends ConsumerStatefulWidget {
  final Suplayer? suplayer;
  const FormSuplayerScreen({super.key, this.suplayer});

  @override
  ConsumerState createState() => _FormCreateNewSuplayerScreenState();
}

class _FormCreateNewSuplayerScreenState
    extends ConsumerState<FormSuplayerScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _noTelpCtrl;
  late TextEditingController _addressCtrl;

  @override
  void initState() {
    Future.microtask(() => ref.read(provinceNotifier.notifier).getAddress());
    _nameCtrl = TextEditingController();
    _noTelpCtrl = TextEditingController();
    _addressCtrl = TextEditingController();
    if (widget.suplayer != null) {
      ///[* set address & form other when edited data]
      Future.microtask(() async {
        Suplayer suplayer = widget.suplayer!;
        ref.read(toggleNotifier.notifier).state = true;
        ref.read(idProvinceProvider.notifier).state =
            suplayer.address?.province?.id;

        ref.read(idRegencyProvider.notifier).state =
            suplayer.address?.regency?.id;
        ref.read(regencyNotifier.notifier).getAddress(0);

        ref.read(idDistrictProvider.notifier).state =
            suplayer.address?.district?.id;
        ref.read(districtNotifier.notifier).getAddress(0);

        ref.read(idVillageProvider.notifier).state =
            suplayer.address?.village?.id;
        ref.read(villagetNotifier.notifier).getAddress(0);

        _nameCtrl.text = suplayer.name ?? "-";
        _noTelpCtrl.text = suplayer.phoneNumber ?? "-";
        _addressCtrl.text = suplayer.address?.detail ?? "-";
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _noTelpCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final province = ref.watch(provinceNotifier).data;
    final regency = ref.watch(regencyNotifier).data;
    final district = ref.watch(districtNotifier).data;
    final village = ref.watch(villagetNotifier).data;
    final isActiveToggle = ref.watch(toggleNotifier);
    final image = ref.watch(imageNotifier);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text("Tambah Suplayer"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1), () {
            ref.read(provinceNotifier.notifier).getAddress();
          });
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15.0),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InkWell(
                    onTap: () async {
                      final newImage = await ref
                          .read(imagePickerProvider.notifier)
                          .getFromGallery();
                      if (newImage != null) {
                        ref.read(imageNotifier.notifier).state = newImage;
                      }
                    },
                    child: Container(
                      height: 150,
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(),
                        image: image == null
                            ? widget.suplayer?.image != null
                                ? DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        "$BASE/${widget.suplayer?.image}"))
                                : null
                            : DecorationImage(
                                image: FileImage(image), fit: BoxFit.cover),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            offset: const Offset(2, 2),
                            blurRadius: 2,
                          )
                        ],
                        color: Theme.of(context).colorScheme.surface,
                      ),
                      child: image == null
                          ? const Icon(Icons.image, size: 35)
                          : null,
                    )),
                FieldInput(
                  title: "Nama Suplayer",
                  hintText: "Masukkan Nama",
                  controller: _nameCtrl,
                  textValidator: "",
                  keyboardType: TextInputType.text,
                  obsecureText: false,
                ),
                FieldInput(
                  title: "No.Telepon",
                  hintText: "Masukkan No.Telepon",
                  controller: _noTelpCtrl,
                  textValidator: "",
                  keyboardType: TextInputType.phone,
                  obsecureText: false,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Harap isi terlebih dahulu";
                    } else if (value.length != 12) {
                      return "Harap isi nomor 12 Angka";
                    }
                    return null;
                  },
                ),

                ///[* toggle button]
                Align(
                  alignment: Alignment.centerLeft,
                  child: OutlinedButton.icon(
                      onPressed: () {
                        ref.read(toggleNotifier.notifier).state =
                            !isActiveToggle;
                      },
                      icon: isActiveToggle
                          ? Icon(
                              Icons.toggle_on,
                              size: 35,
                              color: Theme.of(context).colorScheme.primary,
                            )
                          : const Icon(Icons.toggle_off_outlined, size: 35),
                      label: const Text(
                        "Aktifkan data lokasi",
                      )),
                ),

                ///[* Address form ]
                Visibility(
                    visible: isActiveToggle,
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
                            ref.read(idProvinceProvider.notifier).state = value;

                            ref.invalidate(idRegencyProvider);
                            ref.invalidate(regencyNotifier);

                            ref.invalidate(idDistrictProvider);
                            ref.invalidate(districtNotifier);

                            ref.invalidate(idVillageProvider);
                            ref.invalidate(villagetNotifier);

                            ref.read(regencyNotifier.notifier).getAddress(0);
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
                            ref.read(idRegencyProvider.notifier).state = value;

                            ref.invalidate(idDistrictProvider);
                            ref.invalidate(districtNotifier);

                            ref.invalidate(idVillageProvider);
                            ref.invalidate(villagetNotifier);

                            ref
                                .read(districtNotifier.notifier)
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
                            ref.read(idDistrictProvider.notifier).state = value;
                            ref.invalidate(idVillageProvider);
                            ref.invalidate(villagetNotifier);

                            ref
                                .read(villagetNotifier.notifier)
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
                            ref.read(idVillageProvider.notifier).state = value;
                          },
                        ),
                        FieldInput(
                          maxLines: 5,
                          isRounded: false,
                          hintText: 'Masukkan Alamat Lengkap',
                          controller: _addressCtrl,
                          textValidator: "",
                          keyboardType: TextInputType.multiline,
                          obsecureText: false,
                        ),
                      ],
                    )),

                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _handleCreateNew(),
                  child: ref.watch(createSuplayerNotifier).isLoading
                      ? const LoadingInButton()
                      : const Text("Simpan"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool checkFilledAddress() {
    if (ref.watch(idProvinceProvider) != null &&
        ref.watch(idRegencyProvider) != null &&
        ref.watch(idDistrictProvider) != null &&
        ref.watch(idVillageProvider) != null) {
      return true;
    }
    return false;
  }

  _handleCreateNew() async {
    if (ref.watch(toggleNotifier) && !checkFilledAddress()) {
      showSnackbar(context, "Alamat harap diisi", isWarning: true);
    } else if (_formKey.currentState!.validate()) {
      if (widget.suplayer != null) {
        _updateRequest();
      } else {
        _createRequest();
      }
    }
  }

  _createRequest() {
    final isActiveAddres = ref.watch(toggleNotifier);
    final image = ref.watch(imageNotifier);
    ref
        .read(createSuplayerNotifier.notifier)
        .createSuplayer(
          isActiveAddres,
          image: image,
          name: _nameCtrl.text,
          phoneNumber: _noTelpCtrl.text,
          idProvince: ref.watch(idProvinceProvider),
          idRegency: ref.watch(idRegencyProvider),
          idDistrict: ref.watch(idDistrictProvider),
          idVillage: ref.watch(idVillageProvider),
          detail: _addressCtrl.text,
        )
        .then((result) {
      if (result) {
        showSnackbar(context, "Berhasil menambahkan suplayer");
        Navigator.pop(context);
      } else {
        showSnackbar(
          context,
          ref.watch(createSuplayerNotifier).error!,
          isWarning: true,
        );
      }
    });
  }

  _updateRequest() {
    final image = ref.watch(imageNotifier);
    ref
        .read(createSuplayerNotifier.notifier)
        .updateSuplayer(
          widget.suplayer!.id!,
          image: image,
          name: _nameCtrl.text,
          phoneNumber: _noTelpCtrl.text,
          idProvince: ref.watch(idProvinceProvider),
          idRegency: ref.watch(idRegencyProvider),
          idDistrict: ref.watch(idDistrictProvider),
          idVillage: ref.watch(idVillageProvider),
          detail: _addressCtrl.text,
        )
        .then((result) {
      if (result) {
        showSnackbar(context, "Berhasil memperbaharui suplayer");
        Navigator.pop(context);
      } else {
        showSnackbar(
          context,
          ref.watch(createSuplayerNotifier).error!,
          isWarning: true,
        );
      }
    });
  }
}
