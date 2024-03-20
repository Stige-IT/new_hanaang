import 'dart:io';

import 'package:admin_hanaang/features/employee/provider/employee_provider.dart';
import 'package:admin_hanaang/features/position/provider/order_provider.dart';
import 'package:admin_hanaang/models/employee.dart';
import 'package:admin_hanaang/models/position.dart';
import 'package:admin_hanaang/utils/constant/base_url.dart';
import 'package:admin_hanaang/views/components/modal_bottom_image_picker_option.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../config/theme.dart';
import '../../../../features/image_picker/image_picker.dart';
import '../../../components/form_input.dart';
import '../../../components/loading_in_button.dart';
import '../../../components/snackbar.dart';

class FormCreateEmployeeScreen extends ConsumerStatefulWidget {
  final Employee? employee;

  const FormCreateEmployeeScreen({super.key, this.employee});

  @override
  ConsumerState createState() => _FormCreateEmployeeScreenState();
}

class _FormCreateEmployeeScreenState
    extends ConsumerState<FormCreateEmployeeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _noTelpCtrl;
  late TextEditingController _position;

  getDataPosition() async {
    await ref.watch(positionNotifier.notifier).getPostions();
    final positions = ref.watch(positionNotifier).data;
    ref
        .watch(positionSearchNotifier.notifier)
        .searchPosition(positions!, query: '');
  }

  @override
  void initState() {
    _nameCtrl = TextEditingController();
    _noTelpCtrl = TextEditingController();
    _position = TextEditingController();
    if (widget.employee != null) {
      _nameCtrl.text = widget.employee!.name!;
      _noTelpCtrl.text = widget.employee!.phoneNumber!;
      _position.text = widget.employee?.position?.name ?? "";
    }
    Future.microtask(() async {
      await getDataPosition();
      final positions = ref.watch(positionNotifier).data;

      _position.addListener(() {
        if (_position.text.isNotEmpty) {
          ref.watch(suffixNotifier.notifier).state = true;
          ref
              .watch(positionSearchNotifier.notifier)
              .searchPosition(positions!, query: _position.text);
        } else {
          ref
              .watch(positionSearchNotifier.notifier)
              .searchPosition(positions!, query: '');
          ref.watch(suffixNotifier.notifier).state = false;
        }
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _noTelpCtrl.dispose();
    _position.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isShowSuffix = ref.watch(suffixNotifier);
    final image = ref.watch(imageNotifier);
    final datasearchPosition = ref.watch(positionSearchNotifier);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text("Tambah Karyawan"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (image == null)
                InkWell(
                  onTap: _handleImagePicker,
                  child: Container(
                    height: 150,
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          offset: const Offset(2, 2),
                          blurRadius: 2,
                        )
                      ],
                      image: widget.employee?.image == null
                          ? null
                          : DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  "$BASE/${widget.employee?.image}"),
                            ),
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    child: widget.employee?.image != null
                        ? null
                        : const Icon(Icons.image, size: 35),
                  ),
                )
              else
                InkWell(
                  onTap: _handleImagePicker,
                  child: Container(
                    height: 150,
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          offset: const Offset(2, 2),
                          blurRadius: 2,
                        )
                      ],
                      image: DecorationImage(
                          image: FileImage(image), fit: BoxFit.cover),
                    ),
                  ),
                ),
              FieldInput(
                title: "Jabatan",
                hintText: "Masukkan Jabatan",
                controller: _position,
                textValidator: "",
                keyboardType: TextInputType.text,
                obsecureText: false,
                suffixIcon: !isShowSuffix
                    ? null
                    : IconButton(
                        onPressed: () {
                          _position.clear();
                        },
                        icon: const Icon(Icons.close),
                      ),
                onChanged: (value) {},
              ),
              if (datasearchPosition.isNotEmpty &&
                  datasearchPosition[0].name == 'add')
                InkWell(
                  onTap: () async {
                    final result = await ref
                        .watch(positionNotifier.notifier)
                        .createPostions(name: _position.text);
                    if (result) {
                      if (!mounted) return;
                      getDataPosition();
                      showSnackbar(context, "Berhasil ditambahkan ke jabatan");
                    } else {
                      if (!mounted) return;
                      showSnackbar(context, "Gagal ditambahkan ke jabatan",
                          isWarning: true);
                    }
                  },
                  child: Chip(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    label: Text("+ Tambah Jabatan Baru"),
                  ),
                )
              else
                SizedBox(
                  child: ref.watch(positionNotifier).isLoading
                      ? const LinearProgressIndicator()
                      : Wrap(
                          children: datasearchPosition
                              .map((e) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2.0),
                                    child: InkWell(
                                        onTap: () {
                                          _position.text = e.name!;
                                        },
                                        child: Chip(
                                            backgroundColor:
                                                _position.text == e.name
                                                    ? Theme.of(context).colorScheme.primary
                                                    : null,
                                            label: Text(
                                              e.name!,
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ))),
                                  ))
                              .toList(),
                        ),
                ),
              FieldInput(
                title: "Nama Karyawan",
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
                    return "Harap di isi";
                  } else if (value.length < 12 || value.length > 13) {
                    return "Harap masukkan nomor dengan benar";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: ref.watch(createEmployeeNotifier).isLoading ||
                        ref.watch(updateEmployeeNotifier).isLoading
                    ? () {}
                    : () => _handleSubmit(image),
                child: ref.watch(createEmployeeNotifier).isLoading ||
                        ref.watch(updateEmployeeNotifier).isLoading
                    ? const LoadingInButton()
                    : const Text("Simpan"),
              )
            ],
          ),
        ),
      ),
    );
  }

  _handleImagePicker() async {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        context: context,
        builder: (_) => ModalBottomOptionImagePicker(
              onTapGalery: () async {
                final newImage = await ref
                    .watch(imagePickerProvider.notifier)
                    .getFromGallery(source: ImageSource.gallery);
                if (!mounted) return;
                Navigator.of(_).pop();
                if (newImage != null) {
                  ref.watch(imageNotifier.notifier).state = newImage;
                }
              },
              onTapCamera: () async {
                final newImage = await ref
                    .watch(imagePickerProvider.notifier)
                    .getFromGallery(source: ImageSource.camera);
                if (!mounted) return;
                Navigator.of(_).pop();
                if (newImage != null) {
                  ref.watch(imageNotifier.notifier).state = newImage;
                }
              },
            ));
  }

  _handleSubmit(File? image) async {
    final positions = ref.watch(positionNotifier).data;

    if (_formKey.currentState!.validate()) {
      Position position = positions!.firstWhere(
          (item) => item.name?.toLowerCase() == _position.text.toLowerCase());
      if (widget.employee != null) {
        _updateRequest(position, image);
      } else {
        _createRequest(position, image);
      }
    }
  }

  _createRequest(Position position, File? image) {
    ref
        .read(createEmployeeNotifier.notifier)
        .createNew(position.id!,
            name: _nameCtrl.text, phoneNumber: _noTelpCtrl.text, image: image)
        .then((result) {
      if (result) {
        showSnackbar(context, "Berhasil menambahkan karyawan");
        Navigator.pop(context);
      } else {
        showSnackbar(context, ref.watch(createEmployeeNotifier).error!,
            isWarning: true);
      }
    });
  }

  _updateRequest(Position position, File? image) {
    ref
        .read(updateEmployeeNotifier.notifier)
        .update(widget.employee!.id!, position.id!,
            name: _nameCtrl.text, phoneNumber: _noTelpCtrl.text, image: image)
        .then((result) {
      if (result) {
        showSnackbar(context, "Berhasil memperbaharui data karyawan");
        Navigator.pop(context);
      } else {
        showSnackbar(context, ref.watch(updateEmployeeNotifier).error!,
            isWarning: true);
      }
    });
  }
}

final positionSearchNotifier =
    StateNotifierProvider.autoDispose<PositionSearchNotifier, List<Position>>(
        (ref) {
  return PositionSearchNotifier();
});

class PositionSearchNotifier extends StateNotifier<List<Position>> {
  PositionSearchNotifier() : super([]);

  searchPosition(List<Position> data, {required String query}) {
    List<Position> temp = [];
    if (query.isEmpty) {
      state = data;
    } else {
      for (Position position in data) {
        if (position.name!.toLowerCase().contains(query.toLowerCase())) {
          temp.add(position);
        }
      }
      if (temp.isEmpty) {
        temp.add(Position(name: "add"));
      }
      state = temp;
    }
  }
}

final suffixNotifier = StateProvider.autoDispose<bool>((ref) => false);
final imageNotifier = StateProvider.autoDispose<File?>((ref) => null);
