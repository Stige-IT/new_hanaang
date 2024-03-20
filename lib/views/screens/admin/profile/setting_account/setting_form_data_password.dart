part of "../profile.dart";

class SettingFormDataPassword extends ConsumerStatefulWidget {
  const SettingFormDataPassword({super.key});

  @override
  ConsumerState createState() => _SettingFormDataPasswordState();
}

class _SettingFormDataPasswordState
    extends ConsumerState<SettingFormDataPassword> {
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
    final isObsecure = ref.watch(obsecureNotifier);
    return Form(
      key: _formKey,
      child: Column(
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
                ref.watch(obsecureNotifier.notifier).state = !isObsecure;
              },
              icon: !isObsecure
                  ? const Icon(Icons.check_box_outline_blank)
                  : const Icon(Icons.check_box_outlined),
            ),
            title: const Text("Perlihatkan Password",
                style: TextStyle(fontSize: 12)),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () => _handleUpdatePassword(api),
              child: const Text("Simpan"),
            ),
          ),
          const SizedBox(height: 10),
          if (state.isLoading) const LinearProgressIndicator(),
        ],
      ),
    );
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
            showSnackbar(context, "Berhasil memperbaharui password");
            ref.invalidate(obsecureNotifier);
          } else {
            showSnackbar(context, "Gagal memperbaharui password",
                isWarning: true);
          }
        });
      }
    }
  }
}

final obsecureNotifier = StateProvider<bool>((ref) => false);
