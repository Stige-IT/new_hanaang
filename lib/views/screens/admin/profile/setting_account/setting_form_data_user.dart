part of "../profile.dart";
class SettingFormDataUser extends ConsumerStatefulWidget {
  const SettingFormDataUser({super.key});

  @override
  ConsumerState createState() => _SettingFormDataUserState();
}

class _SettingFormDataUserState extends ConsumerState<SettingFormDataUser> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _nameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _phoneCtrl;

  @override
  void initState() {
    _nameCtrl = TextEditingController();
    _emailCtrl = TextEditingController();
    _phoneCtrl = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    ref.invalidate(imagePickerProvider);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stateUpdate = ref.watch(updateUserNotifier);
    final stateUser = ref.watch(userNotifierProvider);
    final image = ref.watch(imagePickerProvider);
    final user = stateUser.data;
    if (user != null) {
      _nameCtrl.text = user.name ?? "Nama: -";
      _emailCtrl.text = user.email ?? "Email: -";
      _phoneCtrl.text = user.phoneNumber ?? "+62xxxxxxxx";
    }
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          image.path.isNotEmpty
              ? CircleAvatar(
                  radius: 100,
                  backgroundImage: FileImage(image),
                )
              : user?.image == null
                  ? ProfileWithName(user?.name ?? "", radius: 100)
                  : CircleAvatar(
                      radius: 100,
                      backgroundImage: NetworkImage("$BASE/${user!.image}"),
                    ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () =>
                    ref.watch(imagePickerProvider.notifier).getFromGallery(
                          source: ImageSource.gallery,
                        ),
                icon: const Icon(Icons.image),
              ),
              IconButton(
                onPressed: () =>
                    ref.watch(imagePickerProvider.notifier).getFromGallery(
                          source: ImageSource.camera,
                        ),
                icon: const Icon(Icons.camera_alt),
              ),
              const Text("Ganti Foto")
            ],
          ),
          FieldInput(
            title: "Nama Lengkap",
            hintText: "Masukkan Nama",
            controller: _nameCtrl,
            textValidator: "nama",
            keyboardType: TextInputType.text,
            obsecureText: false,
          ),
          FieldInput(
            title: "Alamat email",
            hintText: "Masukkan Alamat Email",
            controller: _emailCtrl,
            textValidator: "Email",
            keyboardType: TextInputType.emailAddress,
            obsecureText: false,
            enable: false,
          ),
          FieldInput(
            title: "Nomor Telepon",
            hintText: "Masukkan Nomor Telepon",
            controller: _phoneCtrl,
            textValidator: "Nomor Telepon",
            keyboardType: TextInputType.phone,
            obsecureText: false,
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (image.path.isNotEmpty) {
                    ref
                        .watch(userNotifierProvider.notifier)
                        .updatePhotoProfile(image: image);
                  }
                  ref
                      .watch(updateUserNotifier.notifier)
                      .updateProfile(
                        name: _nameCtrl.text,
                        phone: _phoneCtrl.text,
                        email: _emailCtrl.text,
                      )
                      .then((value) {
                    if (value) {
                      ref.watch(userNotifierProvider.notifier).getProfile();
                      showSnackbar(
                          context, "Berhasil memperbaharui data profil");
                    } else {
                      final error = ref.watch(updateUserNotifier).error;
                      showSnackbar(context, error.toString(), isWarning: true);
                    }
                  });
                }
              },
              child: const Text("Simpan"),
            ),
          ),
          const SizedBox(height: 10),
          if (stateUpdate.isLoading) const LinearProgressIndicator()
        ],
      ),
    );
  }
}
