import 'package:admin_hanaang/features/password/provider/password_notifer.dart';
import 'package:admin_hanaang/features/password/provider/password_provider.dart';
import 'package:admin_hanaang/views/components/appbar.dart';
import 'package:admin_hanaang/views/components/form_input.dart';
import 'package:admin_hanaang/views/components/loading_in_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final obsecureProvider = StateNotifierProvider<ObsecureNotifier, bool>((ref) {
  return ObsecureNotifier();
});

class ObsecureNotifier extends StateNotifier<bool> {
  ObsecureNotifier() : super(false);

  changeIsObsecure() => state = !state;
}

class EditPasswordScreen extends ConsumerStatefulWidget {
  const EditPasswordScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditPasswordScreenState();
}

class _EditPasswordScreenState extends ConsumerState<EditPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _oldPasswordCtrl;
  late TextEditingController _newPasswordCtrl;
  late TextEditingController _confirmPasswordCtrl;

  @override
  void initState() {
    _oldPasswordCtrl = TextEditingController();
    _newPasswordCtrl = TextEditingController();
    _confirmPasswordCtrl = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _oldPasswordCtrl.dispose();
    _newPasswordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(passwordnotifierProvider);
    final api = ref.watch(passwordnotifierProvider.notifier);
    final isObsecure = ref.watch(obsecureProvider);
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        const AppBarSliver(title: "Edit Password"),
        SliverList(
            delegate: SliverChildListDelegate([
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FieldInput(
                    title: "Password lama",
                    hintText: "Masukkan Password",
                    controller: _oldPasswordCtrl,
                    textValidator: "password",
                    keyboardType: TextInputType.text,
                    obsecureText: !isObsecure,
                  ),
                  FieldInput(
                    title: "Password Baru",
                    hintText: "Masukkan Password Baru",
                    controller: _newPasswordCtrl,
                    textValidator: "password",
                    keyboardType: TextInputType.text,
                    obsecureText: !isObsecure,
                  ),
                  FieldInput(
                    title: "Password Konfirmasi Baru",
                    hintText: "Masukkan Konfirmasi Password Baru ",
                    controller: _confirmPasswordCtrl,
                    textValidator: "password",
                    keyboardType: TextInputType.text,
                    obsecureText: !isObsecure,
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: IconButton(
                      onPressed: () {
                        ref.watch(obsecureProvider.notifier).changeIsObsecure();
                      },
                      icon: !isObsecure
                          ? const Icon(Icons.check_box_outline_blank)
                          : const Icon(Icons.check_box_outlined),
                    ),
                    title: const Text("Perlihatkan Password",
                        style: TextStyle(fontSize: 12)),
                  ),
                  ElevatedButton(
                    onPressed: () => _handleUpdatePassword(api),
                    child: state.isLoading
                        ? const LoadingInButton()
                        : const Text("Simpan"),
                  )
                ],
              ),
            ),
          )
        ]))
      ],
    ));
  }

  void _handleUpdatePassword(PasswordNotifer api) {
    if (_formKey.currentState!.validate()) {
      if (_newPasswordCtrl.text != _confirmPasswordCtrl.text) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          content: Text('Password baru dan password konfirmasi tidak sesuai'),
        ));
      } else {
        api
            .updatePassword(
          oldPassword: _oldPasswordCtrl.text,
          newPassword: _newPasswordCtrl.text,
          confirmPassword: _confirmPasswordCtrl.text,
        )
            .then((value) {
          if (value) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.green,
                content: Text('Berhasil Ubah Password'),
              ),
            );
            Navigator.pop(context);
            ref.invalidate(obsecureProvider);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.red,
                content: Text("Password Tidak sesuai, coba kembali"),
              ),
            );
          }
        });
      }
    }
  }
}
