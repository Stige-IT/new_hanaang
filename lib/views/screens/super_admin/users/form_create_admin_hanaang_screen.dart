import 'dart:io';

import 'package:admin_hanaang/features/admin_hanaang/provider/admin_hanaang_provider.dart';
import 'package:admin_hanaang/models/admin_hanaang.dart';
import 'package:admin_hanaang/views/components/dropdown_container.dart';
import 'package:admin_hanaang/views/components/form_input.dart';
import 'package:admin_hanaang/views/components/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../features/image_picker/image_picker.dart';

final isObsecureProvider =
    StateNotifierProvider.autoDispose<IsObsecureNotifier, bool>((ref) {
  return IsObsecureNotifier();
});

class IsObsecureNotifier extends StateNotifier<bool> {
  IsObsecureNotifier() : super(false);

  setValue(bool newvalue) => state = newvalue;
}

final valueDropdownNotifier =
    StateNotifierProvider<ValueDropdownNotifier, String?>((ref) {
  return ValueDropdownNotifier();
});

class ValueDropdownNotifier extends StateNotifier<String?> {
  ValueDropdownNotifier() : super(null);

  setValue(String newValue) => state = newValue;
}

class FormAdminHanaangScreen extends ConsumerStatefulWidget {
  final AdminHanaang? dataAdmin;

  const FormAdminHanaangScreen({super.key, this.dataAdmin});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FormAdminHanaangScreenState();
}

class _FormAdminHanaangScreenState
    extends ConsumerState<FormAdminHanaangScreen> {
  final emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _phoneNumberCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _passwordCtrl;
  late TextEditingController _passwordConfirmCtrl;

  @override
  void initState() {
    _nameCtrl = TextEditingController();
    _phoneNumberCtrl = TextEditingController();
    _emailCtrl = TextEditingController();
    _passwordCtrl = TextEditingController();
    _passwordConfirmCtrl = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneNumberCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _passwordConfirmCtrl.dispose();
    ref.invalidate(imageNotifier);
    ref.invalidate(valueDropdownNotifier);
    super.dispose();
  }

  Map data = {
    "Admin Order": '6ddd7c18-90e6-46c7-a105-489991970193',
    "Admin Gudang 1": 'b57e9747-f8ac-4d26-a39e-406f38c06eb0',
    "Admin Gudang 2": 'be96d685-2322-11ee-8a79-5ea00b5791d2',
    "Admin Gudang 3": 'c7df2fad-2322-11ee-8a79-5ea00b5791d2',
  };

  @override
  Widget build(BuildContext context) {
    final isObsecure = ref.watch(isObsecureProvider);
    final image = ref.watch(imageNotifier);
    final valueDropdown = ref.watch(valueDropdownNotifier);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text("Tambah Admin"),
      ),
      body: Form(
        key: _globalKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            GestureDetector(
                onTap: _handleGetImage,
                child: image == null
                    ? widget.dataAdmin?.image == null
                        ?  CircleAvatar(
                            radius: 70,
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            child: const Icon(Icons.person,
                                size: 70, color: Colors.black),
                          )
                        : CircleAvatar(
                            backgroundImage: FileImage(image!),
                          )
                    : CircleAvatar(
                        radius: 70,
                        backgroundImage: FileImage(image),
                      )),
            if (image == null)
              const Align(
                alignment: Alignment.center,
                child: Text("Tambahkan Foto"),
              ),
            const SizedBox(height: 10),
            DropdownContainer(
              value: valueDropdown,
              title: "Role",
              items: data
                  .map((key, value) => MapEntry(key,
                      DropdownMenuItem<String>(value: value, child: Text(key))))
                  .values
                  .toList(),
              onChanged: (value) {
                ref
                    .watch(valueDropdownNotifier.notifier)
                    .setValue(value as String);
              },
            ),
            FieldInput(
              title: "Nama",
              hintText: "Masukkan Nama",
              controller: _nameCtrl,
              textValidator: "Nama",
              keyboardType: TextInputType.text,
              obsecureText: false,
            ),
            const SizedBox(height: 10),
            FieldInput(
              title: "Email",
              hintText: "Masukkan Alamat Email",
              controller: _emailCtrl,
              textValidator: "Email",
              keyboardType: TextInputType.emailAddress,
              obsecureText: false,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Harap isi terlebih dahulu";
                } else if (!emailValid.hasMatch(value)) {
                  return "Harap masukkan Email dengan benar";
                }
                return null;
              },
            ),
            ValueListenableBuilder(
              valueListenable: _emailCtrl,
              builder: (_, value, __) {
                if (value.text.isNotEmpty &&
                    emailValid.allMatches(value.text).isEmpty) {
                  return const Text(
                    "Email tidak valid",
                    style: TextStyle(color: Colors.red),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
            const SizedBox(height: 10),
            FieldInput(
              title: "No. Telepon",
              hintText: "Masukkan No Telepon Aktif",
              controller: _phoneNumberCtrl,
              textValidator: "NoTelp",
              keyboardType: TextInputType.phone,
              obsecureText: false,
              maxLength: 13,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Harap isi terlebih dahulu";
                } else if (value.length < 11 || value.length > 13) {
                  return "Harap isi Nomor dengan benar";
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            FieldInput(
              title: "Password",
              hintText: "Masukkan Password min. 8 Karakter",
              controller: _passwordCtrl,
              textValidator: "Password",
              keyboardType: TextInputType.text,
              obsecureText: !isObsecure,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Harap isi terlebih dahulu";
                } else if (value.length < 8) {
                  return "Harap isi password min.8 Karakter";
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            FieldInput(
              title: "Konfirmasi Password",
              hintText: "Masukkan Konfirmasi Password",
              controller: _passwordConfirmCtrl,
              textValidator: "Password Confirm",
              keyboardType: TextInputType.text,
              obsecureText: !isObsecure,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Harap isi terlebih dahulu";
                } else if (value != _passwordCtrl.text) {
                  return "Password tidak sama";
                } else if (value.length < 8) {
                  return "Harap isi password min.8 Karakter";
                }
                return null;
              },
            ),
            ListTile(
              onTap: () {
                ref.watch(isObsecureProvider.notifier).setValue(!isObsecure);
              },
              visualDensity: const VisualDensity(vertical: -4),
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                isObsecure ? Icons.check_box : Icons.check_box_outline_blank,
              ),
              title:
                  const Text("Lihat Password", style: TextStyle(fontSize: 14)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  final roleId = ref.watch(valueDropdownNotifier);
                  if (_globalKey.currentState!.validate() &&
                      valueDropdown != null) {
                    ref
                        .watch(createAdminnNotifier.notifier)
                        .createAdminHanang(
                          roleId: roleId!,
                          name: _nameCtrl.text,
                          email: _emailCtrl.text,
                          phoneNumber: _phoneNumberCtrl.text,
                          password: _passwordCtrl.text,
                          passwordConfirm: _passwordConfirmCtrl.text,
                          image: image,
                        )
                        .then((success) {
                      if (success) {
                        Navigator.of(context).pop();
                        showSnackbar(context, "Berhasil menambah admin");
                      } else {
                        final err = ref.watch(createAdminnNotifier).error!;
                        showSnackbar(context, err, isWarning: true);
                      }
                    });
                  } else {
                    showSnackbar(
                        context, "Gagal menambah admin harap cek kembali data",
                        isWarning: true);
                  }
                },
                child: const Text("Simpan")),
          ],
        ),
      ),
    );
  }

  _handleGetImage() async {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        )),
        context: context,
        builder: (_) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () async {
                    File? newImage = await ref
                        .watch(imagePickerProvider.notifier)
                        .getFromGallery(source: ImageSource.camera);
                    if (newImage != null) {
                      ref.watch(imageNotifier.notifier).state = (newImage);
                    }
                    if (!mounted) return;
                    Navigator.pop(context);
                  },
                  leading: const Icon(Icons.camera_alt),
                  title: const Text("Kamera"),
                ),
                ListTile(
                  onTap: () async {
                    File? newImage = await ref
                        .watch(imagePickerProvider.notifier)
                        .getFromGallery(source: ImageSource.gallery);
                    if (newImage != null) {
                      ref.watch(imageNotifier.notifier).state = (newImage);
                    }
                    if (!mounted) return;
                    Navigator.pop(context);
                  },
                  leading: const Icon(Icons.image),
                  title: const Text("Galeri"),
                ),
              ],
            ),
          );
        });
  }
}

final imageNotifier = StateProvider<File?>((ref) => null);
