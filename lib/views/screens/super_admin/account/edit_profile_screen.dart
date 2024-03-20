import 'dart:io';

import 'package:admin_hanaang/config/theme.dart';
import 'package:admin_hanaang/features/image_picker/image_picker.dart';
import 'package:admin_hanaang/features/user/provider/user_provider.dart';
import 'package:admin_hanaang/views/components/appbar.dart';
import 'package:admin_hanaang/views/components/form_input.dart';
import 'package:admin_hanaang/views/components/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/user.dart';
import '../../../../utils/constant/base_url.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final User? user;

  const EditProfileScreen({super.key, this.user});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _noTelpCtrl;

  @override
  void initState() {
    _nameCtrl = TextEditingController(text: widget.user?.name);
    _emailCtrl = TextEditingController(text: widget.user?.email);
    _noTelpCtrl = TextEditingController(text: widget.user?.phoneNumber);
    super.initState();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _noTelpCtrl.dispose();
    ref.invalidate(imagePickerProvider);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = ref.watch(userNotifierProvider).data;
    final state = ref.watch(userNotifierProvider);
    File image = ref.watch(imagePickerProvider);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: CustomScrollView(slivers: [
          AppBarSliver(
            title: "Edit Data Profil",
            image: user?.image == null
                ? const Icon(
                    Icons.account_circle,
                    size: 50,
                    color: Colors.white,
                  )
                : InkWell(
                    onTap: () => dialogImagePicker(image, user?.image),
                    child: userImage(user),
                  ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            Container(
              margin: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FieldInput(
                      title: "Nama",
                      hintText: "Masukkan Nama",
                      controller: _nameCtrl,
                      textValidator: "Nama",
                      keyboardType: TextInputType.text,
                      obsecureText: false,
                    ),
                    FieldInput(
                      title: "Email",
                      hintText: "Masukkan Email",
                      controller: _emailCtrl,
                      textValidator: "Nama",
                      keyboardType: TextInputType.text,
                      obsecureText: false,
                      enable: false,
                    ),
                    FieldInput(
                      title: "No Telepon",
                      hintText: "Masukkan No Telepon",
                      controller: _noTelpCtrl,
                      textValidator: "Nama",
                      keyboardType: TextInputType.number,
                      obsecureText: false,
                    ),
                    const SizedBox(height: 25),
                    ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ref
                                .watch(updateUserNotifier.notifier)
                                .updateProfile(
                                  name: _nameCtrl.text,
                                  email: _emailCtrl.text,
                                  phone: _noTelpCtrl.text,
                                )
                                .then((value) {
                              if (value) {
                                ref
                                    .watch(userNotifierProvider.notifier)
                                    .getProfile();
                                Navigator.pop(context);
                                showSnackbar(context, "Berhasil Update Profil");
                              } else {
                                final error =
                                    ref.watch(updateUserNotifier).error;
                                showSnackbar(context, error.toString(),
                                    isWarning: true);
                              }
                            });
                          }
                        },
                        child: state.isLoading
                            ? const SizedBox(
                                height: 25,
                                width: 25,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : const Text("Simpan"))
                  ],
                ),
              ),
            )
          ]))
        ]),
      ),
    );
  }

  Future<dynamic> dialogImagePicker(File? image, String? imageUser) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => Builder(builder: (context) {
              Size size = MediaQuery.of(context).size;
              return StatefulBuilder(builder: (context, setState) {
                return AlertDialog(
                  scrollable: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  contentPadding: const EdgeInsets.all(10),
                  insetPadding: const EdgeInsets.all(20),
                  content: SizedBox(
                    // height: size.height * 0.35,
                    width: size.width,
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () async {
                            final File newImage = await ref
                                .watch(imagePickerProvider.notifier)
                                .getFromGallery();
                            setState(() {
                              image = newImage;
                            });
                          },
                          child: imageUser != null
                              ? CircleAvatar(
                                  backgroundColor: Theme.of(context).colorScheme.primary,
                                  radius: 100,
                                  backgroundImage:
                                      image != null ? FileImage(image!) : null,
                                  child: image != null
                                      ? const Icon(
                                          Icons.image,
                                          size: 70,
                                          color: Colors.white,
                                        )
                                      : null,
                                )
                              : Container(
                                  height: 200,
                                  width: 200,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.network(
                                    "$BASE/$imageUser",
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                          Icons.image_not_supported_outlined);
                                    },
                                  ),
                                ),
                        ),
                        const Text("Upload Foto")
                      ],
                    ),
                  ),
                  actions: [
                    OutlinedButton(
                        onPressed: () {
                          ref.invalidate(imagePickerProvider);
                          Navigator.pop(context);
                        },
                        child: const Text("Kembali")),
                    ElevatedButton(
                        onPressed: () {
                          ref
                              .watch(userNotifierProvider.notifier)
                              .updatePhotoProfile(image: image)
                              .then((value) => Navigator.pop(context));
                        },
                        child: const Text("Simpan"))
                  ],
                );
              });
            }));
  }

  CircleAvatar imagepickerUser(File image) {
    return CircleAvatar(
      radius: 25,
      backgroundImage: FileImage(image),
      backgroundColor: Colors.white,
      child: Icon(
        Icons.image,
        color: Colors.white.withOpacity(0.7),
      ),
      onBackgroundImageError: (exception, stackTrace) {
        return;
      },
    );
  }

  CircleAvatar userImage(User? user) {
    return CircleAvatar(
      radius: 25,
      backgroundImage: NetworkImage("$BASE/${user?.image}"),
      backgroundColor: Colors.white,
      onBackgroundImageError: (exception, stackTrace) {},
      child: Icon(
        Icons.image,
        color: Colors.white.withOpacity(0.7),
      ),
    );
  }
}
