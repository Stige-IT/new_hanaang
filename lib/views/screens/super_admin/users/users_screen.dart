import 'package:admin_hanaang/features/admin_hanaang/provider/admin_hanaang_provider.dart';
import 'package:admin_hanaang/features/users_hanaang/provider/users_hanaang_providers.dart';
import 'package:admin_hanaang/views/components/appbar.dart';
import 'package:admin_hanaang/views/components/navigation_widget.dart';
import 'package:admin_hanaang/views/components/tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/router/router_config.dart';
import '../../../../config/theme.dart';
import '../../../components/card_total_users.dart';
import '../../../components/form_input.dart';
import '../../../components/snackbar.dart';

class UsersScreen extends ConsumerStatefulWidget {
  const UsersScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UsersScreenState();
}

class _UsersScreenState extends ConsumerState<UsersScreen> {
  String? selectedRole;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _phoneNumber;
  late TextEditingController _emailCtrl;
  late TextEditingController _passwordCtrl;
  late TextEditingController _passwordConfirmCtrl;

  getDataUsersHanaang() {
    ref.watch(userDistributorNotifier.notifier).getUsersHanaang();
    ref.watch(userAgenNotifier.notifier).getUsersHanaang();
    ref.watch(userWargaNotifier.notifier).getUsersHanaang();
    ref.watch(userFamilyNotifier.notifier).getUsersHanaang();
    ref.watch(newUserNotifier.notifier).getUsersHanaang();
    ref.watch(totalAdminHanaangNotifier.notifier).getTotal();
  }

  getData({String? role}) async {
    switch (role) {
      case "distributor":
        ref.watch(userDistributorNotifier.notifier).getUsersHanaang();
        break;
      case "agen":
        ref.watch(userAgenNotifier.notifier).getUsersHanaang();
        break;
      case "warga":
        ref.watch(userWargaNotifier.notifier).getUsersHanaang();
        break;
      case "keluarga":
        ref.watch(userFamilyNotifier.notifier).getUsersHanaang();
        break;
      case "user":
        ref.watch(newUserNotifier.notifier).getUsersHanaang();
        break;
      default:
        getDataUsersHanaang();
    }
  }

  @override
  void initState() {
    Future.microtask(() {
      ref.watch(totalAdminHanaangNotifier.notifier).getTotal();
      ref.watch(totalUserNotifier.notifier).getTotal();
    });
    _nameCtrl = TextEditingController();
    _phoneNumber = TextEditingController();
    _emailCtrl = TextEditingController();
    _passwordCtrl = TextEditingController();
    _passwordConfirmCtrl = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneNumber.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _passwordConfirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final distributor = ref.watch(totalUserNotifier).totalDistributor;
    final agen = ref.watch(totalUserNotifier).totalAgen;
    final warga = ref.watch(totalUserNotifier).totalWarga;
    final keluarga = ref.watch(totalUserNotifier).totalKeluarga;
    final newUser = ref.watch(totalUserNotifier).totalPengguna;
    final totalAdmin = ref.watch(totalAdminHanaangNotifier).total;
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1), () {
          ref.watch(totalAdminHanaangNotifier.notifier).getTotal();
          ref.watch(totalUserNotifier.notifier).getTotal();
        });
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          label: const Text("Pengguna Baru"),
          icon: const Icon(Icons.add),
          onPressed: _handleCreateNewUser,
        ),
        body: CustomScrollView(slivers: [
          const AppBarSliver(),
          SliverList(
              delegate: SliverChildListDelegate([
            GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(10),
              // physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              childAspectRatio: 2 / 1.5,
              crossAxisCount: 3,
              children: [
                CardUsers(
                  title: "Distributor",
                  total: distributor,
                  onTap: () => nextPage(context, "${AppRoutes.sa}/users",
                      argument: "Distributor"),
                ),
                CardUsers(
                  title: "Agen",
                  total: agen,
                  onTap: () => nextPage(context, "${AppRoutes.sa}/users",
                      argument: "Agen"),
                ),
                CardUsers(
                  title: "Warga",
                  total: warga,
                  onTap: () => nextPage(context, "${AppRoutes.sa}/users",
                      argument: "Warga"),
                ),
                CardUsers(
                  title: "Keluarga",
                  total: keluarga,
                  onTap: () => nextPage(context, "${AppRoutes.sa}/users",
                      argument: "Keluarga"),
                ),
                CardUsers(
                  title: "Pengguna Baru",
                  total: newUser,
                  onTap: () => nextPage(context, "${AppRoutes.sa}/users",
                      argument: "User"),
                ),
                CardUsers(
                  title: "Admin",
                  total: totalAdmin,
                  onTap: () {
                    nextPage(context, "${AppRoutes.sa}/admin-hanaang");
                  },
                ),
              ],
            ),
            Tile(
              title: "Daftar Pembeli",
              onTap: () => nextPage(context, "${AppRoutes.sa}/users",
                  argument: "Pengguna"),
            ),
            Tile(
              title: "Daftar Warung",
              onTap: () => nextPage(context, "${AppRoutes.sa}/markets"),
            ),
            Tile(
              title: "Daftar Admin",
              onTap: () => nextPage(context, "${AppRoutes.sa}/admin-hanaang"),
            ),
          ]))
        ]),
      ),
    );
  }

  _handleCreateNewUser() {
    Map data = {
      "Distributor": "4b736cf3-3d81-4c39-8e44-1a7ebf16422d",
      "Agen": "52bcee5d-57ea-4037-b7cd-a8e0b3f3555f",
      "Warga": "fbf8807d-0f97-4c1a-b42f-e14d7901f9c2",
      "Keluarga": "d627b4bb-7243-49e7-913e-78e8a983c9f5",
      "Pengguna": "c1ecf558-5e51-4f40-b657-e65b54985847",
    };
    Size size = MediaQuery.of(context).size;
    showDialog(
        context: context,
        builder: (_) => StatefulBuilder(builder: (_, setState) {
              return AlertDialog(
                scrollable: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                insetPadding: const EdgeInsets.all(15.0),
                title: SizedBox(
                  width: size.width,
                  child: const Text("Tambah Pengguna baru"),
                ),
                content: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(2, 2),
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 5,
                              )
                            ]),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            value: selectedRole,
                            borderRadius: BorderRadius.circular(15),
                            hint: const Text("Silahkan Pilih Role"),
                            isExpanded: true,
                            items: data
                                .map((key, value) => MapEntry(
                                      key,
                                      DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(key),
                                      ),
                                    ))
                                .values
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedRole = value;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      FieldInput(
                        title: "Nama",
                        hintText: "Masukkan Nama",
                        controller: _nameCtrl,
                        textValidator: "",
                        keyboardType: TextInputType.text,
                        obsecureText: false,
                      ),
                      const SizedBox(height: 10),
                      FieldInput(
                        title: "No.Telepon",
                        hintText: "Masukkan No.Telepon",
                        controller: _phoneNumber,
                        textValidator: "",
                        keyboardType: TextInputType.phone,
                        obsecureText: false,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Harap isi terlebih dahulu";
                          } else if (value.length < 11) {
                            return "Nomor telepon harus 11+ Karakter";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      FieldInput(
                        title: "Email",
                        hintText: "Masukkan Email",
                        controller: _emailCtrl,
                        textValidator: "",
                        keyboardType: TextInputType.text,
                        obsecureText: false,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Harap di isi";
                          } else if (!value.contains("@")) {
                            return "Masukkan email valid";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      FieldInput(
                        title: "Password",
                        hintText: "Password +8 Karakter",
                        controller: _passwordCtrl,
                        textValidator: "",
                        keyboardType: TextInputType.text,
                        obsecureText: true,
                      ),
                      const SizedBox(height: 10),
                      FieldInput(
                        title: "Konfirmasi Password",
                        hintText: "Masukkan Password",
                        controller: _passwordConfirmCtrl,
                        textValidator: "",
                        keyboardType: TextInputType.text,
                        obsecureText: true,
                        validator: (value) {
                          if (value != _passwordCtrl.text) {
                            return "Password tidak sama";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                clearTextEditing();
                              },
                              child: const Text("Kembali")),
                          const SizedBox(width: 20),
                          ElevatedButton(
                              onPressed: _handleSubmitCreateNew,
                              child: const Text("Simpan")),
                        ],
                      )
                    ],
                  ),
                ),
              );
            }));
  }

  _handleSubmitCreateNew() {
    if (_formKey.currentState!.validate()) {
      ref
          .watch(createUserNotifier.notifier)
          .create(
            selectedRole!,
            name: _nameCtrl.text,
            email: _emailCtrl.text,
            phoneNumber: _phoneNumber.text,
            password: _passwordCtrl.text,
            passwordConfirmation: _passwordConfirmCtrl.text,
          )
          .then((success) {
        Navigator.of(context).pop();
        if (success) {
          showSnackbar(
            context,
            "Berhasil tambah pengguna Baru",
          );
          clearTextEditing();
          ref.watch(totalUserNotifier.notifier).getTotal();
        } else {
          final error = ref.read(createUserNotifier).error;
          showSnackbar(context, error!, isWarning: true);
        }
      });
    }
  }

  clearTextEditing() {
    selectedRole = null;
    _nameCtrl.clear();
    _phoneNumber.clear();
    _emailCtrl.clear();
    _passwordCtrl.clear();
    _passwordConfirmCtrl.clear();
  }
}
