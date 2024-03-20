part of "../suplayer.dart";

final isShowAddressProvider = StateProvider.autoDispose<bool>((ref) => false);
final imageProvider = StateProvider.autoDispose<File?>((ref) => null);

class FormSuplayerScreenAdmin extends ConsumerStatefulWidget {
  final Suplayer? suplayer;

  const FormSuplayerScreenAdmin({super.key, this.suplayer});

  @override
  ConsumerState createState() => _FormSuplayerScreenAdminState();
}

class _FormSuplayerScreenAdminState
    extends ConsumerState<FormSuplayerScreenAdmin> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _detailAddressController;

  @override
  void initState() {
    _nameController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _detailAddressController = TextEditingController();
    if (widget.suplayer != null) {
      ///[* set address & form other when edited data]
      Future.microtask(() async {
        ref.watch(provinceNotifier.notifier).getAddress();
        Suplayer suplayer = widget.suplayer!;
        ref
            .watch(isShowAddressProvider.notifier)
            .state = true;
        ref
            .watch(idProvinceProvider.notifier)
            .state =
            suplayer.address?.province?.id;

        ref
            .watch(idRegencyProvider.notifier)
            .state =
            suplayer.address?.regency?.id;
        ref.watch(regencyNotifier.notifier).getAddress(0);

        ref
            .watch(idDistrictProvider.notifier)
            .state =
            suplayer.address?.district?.id;
        ref.watch(districtNotifier.notifier).getAddress(0);

        ref
            .watch(idVillageProvider.notifier)
            .state =
            suplayer.address?.village?.id;
        ref.watch(villagetNotifier.notifier).getAddress(0);

        _nameController.text = suplayer.name ?? "-";
        _phoneNumberController.text = suplayer.phoneNumber ?? "-";
        _detailAddressController.text = suplayer.address?.detail ?? "-";
      });
      super.initState();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _detailAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isShow = ref.watch(isShowAddressProvider);
    final image = ref.watch(imageProvider);
    final setImage = ref.watch(imageProvider.notifier);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppbarAdmin(scaffoldKey: _scaffoldKey, title: "Form Suplayer"),
      endDrawer: const EndrawerWidget(),
      body: Form(
        key: _formKey,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 70.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (image != null)
                          CircleAvatar(
                              radius: 70, backgroundImage: FileImage(image))
                        else
                          Builder(builder: (context) {
                            if (widget.suplayer != null) {
                              return CircleAvatarNetwork(
                                "$BASE/${widget.suplayer!.image}",
                                radius: 140,
                              );
                            }
                            return CircleAvatar(
                              backgroundColor: Colors.grey[200],
                              radius: 70,
                              child: const Icon(
                                Icons.image,
                                size: 50,
                                color: Colors.black,
                              ),
                            );
                          }),
                        const SizedBox(width: 20),
                        FilledButton(
                          onPressed: () {
                            showModalBottomSheet(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                topRight: Radius.circular(15),
                                topLeft: Radius.circular(15),
                              )),
                              context: context,
                              builder: (_) => ModalBottomOptionImagePicker(
                                onTapCamera: () async {
                                  Navigator.of(context).pop();
                                  setImage.state = await ref
                                      .read(imagePickerProvider.notifier)
                                      .getFromGallery(
                                        source: ImageSource.camera,
                                      );
                                },
                                onTapGalery: () async {
                                  Navigator.of(context).pop();
                                  setImage.state = await ref
                                      .read(imagePickerProvider.notifier)
                                      .getFromGallery(
                                        source: ImageSource.gallery,
                                      );
                                },
                              ),
                            );
                          },
                          child: const Text("Pilih gambar"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    FieldInput(
                      title: "Nama",
                      hintText: "Masukkan Nama",
                      controller: _nameController,
                      textValidator: "",
                      keyboardType: TextInputType.text,
                      obsecureText: false,
                    ),
                    FieldInput(
                      title: "No.Telepon",
                      hintText: "Masukkan Nomor telepon aktif",
                      controller: _phoneNumberController,
                      textValidator: "",
                      keyboardType: TextInputType.number,
                      obsecureText: false,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Harap isi";
                        } else if (value.length < 11 || value.length > 12) {
                          return "Masukkan 11-12 angka";
                        }
                        return null;
                      },
                    ),
                    TextButton.icon(
                      onPressed: () {
                        if (!isShow) {
                          ref.watch(provinceNotifier.notifier).getAddress();
                        }
                        ref.read(isShowAddressProvider.notifier).state =
                            !isShow;
                      },
                      icon: isShow
                          ? Icon(Icons.toggle_on, color: Theme.of(context).colorScheme.primary)
                          : const Icon(Icons.toggle_off_outlined),
                      label: const Text("Tambah alamat"),
                    )
                  ],
                ),
              ),
            ),
            const Divider(thickness: 2),
            Expanded(
              child: Builder(builder: (_) {
                if (!isShow) {
                  return const Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_location_outlined),
                      SizedBox(height: 10),
                      Text("Aktifkan alamat, jika ingin menambahkan alamat"),
                    ],
                  ));
                } else {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 70.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownContainer(
                          title: "Provinsi",
                          value: ref.watch(idProvinceProvider),
                          items: (ref.watch(provinceNotifier).data ?? [])
                              .map((province) {
                            return DropdownMenuItem(
                              value: province.id,
                              child: Text(province.name),
                            );
                          }).toList(),
                          onChanged: (value) {
                            ref.read(idProvinceProvider.notifier).state = value;
                            ref.read(regencyNotifier.notifier).getAddress(0);
                            ref.invalidate(idRegencyProvider);
                            ref.invalidate(idDistrictProvider);
                            ref.invalidate(districtNotifier);
                            ref.invalidate(idVillageProvider);
                            ref.invalidate(villagetNotifier);
                          },
                        ),
                        DropdownContainer(
                          title: "Kabupaten",
                          value: ref.watch(idRegencyProvider),
                          items: (ref.watch(regencyNotifier).data ?? [])
                              .map((regency) => DropdownMenuItem(
                                  value: regency.id, child: Text(regency.name)))
                              .toList(),
                          onChanged: (value) {
                            ref.watch(idRegencyProvider.notifier).state = value;
                            ref.read(districtNotifier.notifier).getAddress(0);
                            ref.invalidate(idDistrictProvider);
                            ref.invalidate(idVillageProvider);
                            ref.invalidate(villagetNotifier);
                          },
                        ),
                        DropdownContainer(
                          title: "Kecamatan",
                          value: ref.watch(idDistrictProvider),
                          items: (ref.watch(districtNotifier).data ?? [])
                              .map((district) => DropdownMenuItem(
                                  value: district.id,
                                  child: Text(district.name)))
                              .toList(),
                          onChanged: (value) {
                            ref.watch(idDistrictProvider.notifier).state =
                                value;
                            ref.read(villagetNotifier.notifier).getAddress(0);
                            ref.invalidate(idVillageProvider);
                          },
                        ),
                        DropdownContainer(
                          title: "Kelurahan",
                          value: ref.watch(idVillageProvider),
                          items: (ref.watch(villagetNotifier).data ?? [])
                              .map((village) => DropdownMenuItem(
                                  value: village.id, child: Text(village.name)))
                              .toList(),
                          onChanged: (value) {
                            ref.watch(idVillageProvider.notifier).state = value;
                          },
                        ),
                        FieldInput(
                          title: "Detail alamat",
                          hintText: "Masukkan detail alamat",
                          controller: _detailAddressController,
                          textValidator: "",
                          keyboardType: TextInputType.multiline,
                          obsecureText: false,
                          maxLines: 3,
                          isRounded: false,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Harap isi";
                            } else if (_isNotFilled()) {
                              return "Harap pilih alamat diatas";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  );
                }
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _handleSaveDataSuplayer();
          }
        },
        label: ref.watch(createSuplayerNotifier).isLoading
            ? const LoadingInButton()
            : const Text("Simpan"),
      ),
    );
  }

  bool _isNotFilled() {
    if (ref.watch(idProvinceProvider) == null ||
        ref.watch(idRegencyProvider) == null ||
        ref.watch(idDistrictProvider) == null ||
        ref.watch(idVillageProvider) == null) {
      return true;
    }
    return false;
  }

  _handleSaveDataSuplayer() {
    final image = ref.watch(imageProvider);
    final isShow = ref.watch(isShowAddressProvider);
    PanaraConfirmDialog.show(
      context,
      message: "Simpan data suplayer?",
      confirmButtonText: "Simpan",
      cancelButtonText: "Kembali",
      onTapConfirm: () {
        Navigator.of(context).pop();
        if (widget.suplayer != null) {
          ref
              .read(createSuplayerNotifier.notifier)
              .updateSuplayer(
                widget.suplayer!.id!,
                name: _nameController.text,
                phoneNumber: _phoneNumberController.text,
                idProvince: ref.watch(idProvinceProvider),
                idRegency: ref.watch(idProvinceProvider),
                idDistrict: ref.watch(idRegencyProvider),
                idVillage: ref.watch(idVillageProvider),
                detail: _detailAddressController.text,
                image: image,
              )
              .then((success) {
            if (success) {
              Navigator.of(context).pop();
              showSnackbar(context, "Berhasil memperbaharui suplayer");
            } else {
              final msg = ref.watch(createSuplayerNotifier).error;
              showSnackbar(context, msg!, isWarning: true);
            }
          });
        } else {
          ref
              .read(createSuplayerNotifier.notifier)
              .createSuplayer(
                isShow,
                name: _nameController.text,
                phoneNumber: _phoneNumberController.text,
                idProvince: ref.watch(idProvinceProvider),
                idRegency: ref.watch(idProvinceProvider),
                idDistrict: ref.watch(idRegencyProvider),
                idVillage: ref.watch(idVillageProvider),
                detail: _detailAddressController.text,
                image: image,
              )
              .then((success) {
            if (success) {
              Navigator.of(context).pop();
              showSnackbar(context, "Berhasil menambah suplayer");
            } else {
              final msg = ref.watch(createSuplayerNotifier).error;
              showSnackbar(context, msg!, isWarning: true);
            }
          });
        }
      },
      onTapCancel: Navigator.of(context).pop,
      panaraDialogType: PanaraDialogType.warning,
    );
  }
}
