import 'package:admin_hanaang/features/users_hanaang/provider/users_hanaang_providers.dart';
import 'package:admin_hanaang/views/components/form_input.dart';
import 'package:admin_hanaang/views/components/loading_in_button.dart';
import 'package:admin_hanaang/views/components/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../components/dropdown_container.dart';
import '../../../../../../utils/helper/formatted_role.dart' as helper;

final roleSelectedProvider = StateProvider.autoDispose<String?>((ref) => null);
final isObsecureProvider = StateProvider.autoDispose<bool>((ref) => true);

class FormUser extends ConsumerStatefulWidget {
  const FormUser({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FormUserState();
}

class _FormUserState extends ConsumerState<FormUser> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _noTeleponCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _passwordCtrl;
  late TextEditingController _passwordConfirmCtrl;

  @override
  void initState() {
    _nameCtrl = TextEditingController();
    _noTeleponCtrl = TextEditingController();
    _emailCtrl = TextEditingController();
    _passwordCtrl = TextEditingController();
    _passwordConfirmCtrl = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _noTeleponCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _passwordConfirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final roleUsers = helper.data;
    final isObsecure = ref.watch(isObsecureProvider);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownContainer(
                title: "Role Pengguna",
                value: ref.watch(roleSelectedProvider),
                items: roleUsers
                    .map(
                      (key, value) => MapEntry(
                        key,
                        DropdownMenuItem<String>(
                            value: value, child: Text(key)),
                      ),
                    )
                    .values
                    .toList(),
                onChanged: (value) {
                  ref.read(roleSelectedProvider.notifier).state = value;
                },
              ),
              FieldInput(
                title: "Nama pengguna",
                hintText: "Masukkan Nama",
                controller: _nameCtrl,
                textValidator: "",
                keyboardType: TextInputType.text,
                obsecureText: false,
              ),
              FieldInput(
                title: "No.Telepon",
                hintText: "Masukkan no.telepon aktif",
                controller: _noTeleponCtrl,
                textValidator: "",
                keyboardType: TextInputType.phone,
                obsecureText: false,
                validator: (value) {
                  if (value!.isEmpty || value.length < 11) {
                    return "Nomor telepon harus 11+ Karakter";
                  }
                  return null;
                },
              ),
              FieldInput(
                title: "Alamat email",
                hintText: "Masukkan email",
                controller: _emailCtrl,
                textValidator: "",
                keyboardType: TextInputType.emailAddress,
                obsecureText: false,
              ),
              FieldInput(
                title: "Password",
                hintText: "Password +8 karakter",
                controller: _passwordCtrl,
                textValidator: "",
                keyboardType: TextInputType.text,
                obsecureText: isObsecure,
              ),
              FieldInput(
                title: "Konfirmasi Password",
                hintText: "Masukkan Password yang sama",
                controller: _passwordConfirmCtrl,
                textValidator: "",
                keyboardType: TextInputType.text,
                obsecureText: isObsecure,
                validator: (value) {
                  if (value != _passwordCtrl.text) {
                    return "Password tidak sama";
                  }
                  return null;
                },
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton.icon(
                  onPressed: () {
                    ref.read(isObsecureProvider.notifier).state = !isObsecure;
                  },
                  icon: Icon(!isObsecure
                      ? Icons.check_box
                      : Icons.check_box_outline_blank),
                  label: const Text("Lihat password"),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() &&
                        ref.watch(roleSelectedProvider) != null) {
                      ref
                          .read(createUserNotifier.notifier)
                          .create(
                            ref.watch(roleSelectedProvider)!,
                            name: _nameCtrl.text,
                            email: _emailCtrl.text,
                            phoneNumber: _noTeleponCtrl.text,
                            password: _passwordCtrl.text,
                            passwordConfirmation: _passwordConfirmCtrl.text,
                          )
                          .then((success) {
                        if (success) {
                          Navigator.of(context).pop();
                          showSnackbar(
                              context, "Pengguna baru berhasil di daftarkan");
                        } else {
                          final error = ref.watch(createUserNotifier).error;
                          showSnackbar(context, error!, isWarning: true);
                        }
                      });
                    }
                  },
                  child: ref.watch(createUserNotifier).isLoading
                      ? const LoadingInButton()
                      : const Text("Simpan"))
            ],
          ),
        ),
      ),
    );
  }
}
