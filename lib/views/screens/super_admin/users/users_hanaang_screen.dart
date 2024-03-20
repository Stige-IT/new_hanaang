import 'package:admin_hanaang/features/users_hanaang/data/users_hanaang_api.dart';
import 'package:admin_hanaang/features/users_hanaang/provider/users_hanaang_providers.dart';
import 'package:admin_hanaang/models/users_hanaang.dart';
import 'package:admin_hanaang/utils/constant/base_url.dart';
import 'package:admin_hanaang/utils/extensions/capital_first.dart';
import 'package:admin_hanaang/views/components/form_input.dart';
import 'package:admin_hanaang/views/components/snackbar.dart';
import 'package:admin_hanaang/views/screens/super_admin/users/detail_users_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

final isShowSearchProvider = StateProvider.autoDispose<bool>((ref) => false);

class UsersHanaangScreen extends ConsumerStatefulWidget {
  final String? title;

  const UsersHanaangScreen({super.key, this.title});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UsersHanaangScreenState();
}

class _UsersHanaangScreenState extends ConsumerState<UsersHanaangScreen> {
  String? selectedRole;

  List filteredUsers = ["Distributor", "Agen", "Keluarga", "Warga", "Pengguna"];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _searchCtrl;
  late TextEditingController _nameCtrl;
  late TextEditingController _phoneNumber;
  late TextEditingController _emailCtrl;
  late TextEditingController _passwordCtrl;
  late TextEditingController _passwordConfirmCtrl;
  late ScrollController _scrollCtrl;

  @override
  void initState() {
    Future.microtask(() {
      if (widget.title != null) {
        ref.watch(roleNameUserProvider.notifier).state = widget.title!;
      }
      ref.watch(userNotifier.notifier).getData();
    });
    _searchCtrl = TextEditingController();
    _nameCtrl = TextEditingController();
    _phoneNumber = TextEditingController();
    _emailCtrl = TextEditingController();
    _passwordCtrl = TextEditingController();
    _passwordConfirmCtrl = TextEditingController();
    _scrollCtrl = ScrollController();

    _scrollCtrl.addListener(() {
      if (_scrollCtrl.position.pixels == _scrollCtrl.position.maxScrollExtent) {
        if (ref.watch(userNotifier).page < ref.watch(userNotifier).totalPage!) {
          print("Get Data more");
          ref.read(userNotifier.notifier).loadMoreData();
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _nameCtrl.dispose();
    _phoneNumber.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _passwordConfirmCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  clearTextEditing() {
    _nameCtrl.clear();
    _phoneNumber.clear();
    _emailCtrl.clear();
    _passwordCtrl.clear();
    _passwordConfirmCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    String nameRole = ref.watch(roleNameUserProvider);
    bool isLoading = ref.watch(userNotifier).isLoading;
    bool isLoadingMore = ref.watch(userNotifier).isLoadingMore;
    bool isShowSearch = ref.watch(isShowSearchProvider);
    List<UsersHanaang>? data = ref.watch(userNotifier).data;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: isShowSearch
            ? TextField(
                controller: _searchCtrl,
                autofocus: true,
                cursorColor: Colors.white,
                style: const TextStyle(color: Colors.white),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    ref.watch(userNotifier.notifier).searchData(value);
                  }
                },
              )
            : Text(
                nameRole == "User" ? "PENGGUNA" : nameRole.toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
        actions: [
          IconButton(
              onPressed: () {
                if (isShowSearch) {
                  _searchCtrl.clear();
                  ref.read(userNotifier.notifier).refresh(makeLoading: true);
                }
                ref.read(isShowSearchProvider.notifier).state = !isShowSearch;
              },
              icon: isShowSearch
                  ? const Icon(Icons.close)
                  : const Icon(Icons.search)),
          if (!isShowSearch)
            PopupMenuButton<String>(
                icon: const Icon(Icons.filter_alt),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                onSelected: (value) {
                  ref.watch(roleNameUserProvider.notifier).state = value;
                  ref.watch(userNotifier.notifier).getData();
                },
                itemBuilder: (_) {
                  return filteredUsers.map((user) {
                    user = user == "Pengguna" ? "User" : user;
                    return PopupMenuItem<String>(
                        value: user,
                        child: Text(
                          user == "User" ? "Pengguna" : user,
                          style: TextStyle(
                            fontWeight:
                                nameRole == user ? FontWeight.bold : null,
                          ),
                        ));
                  }).toList();
                }),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1), () {
            ref.watch(userNotifier.notifier).refresh(makeLoading: true);
          });
        },
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : data!.isEmpty
                ? const Center(child: Text("Tidak ada data"))
                : ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(
                        top: 10.0, bottom: 100, left: 10.0, right: 10.0),
                    controller: _scrollCtrl,
                    itemCount: isLoadingMore ? data.length + 1 : data.length,
                    itemBuilder: (_, index) {
                      if (isLoadingMore && index == data.length) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      UsersHanaang user = data[index];
                      return Card(
                        color: Theme.of(context).colorScheme.surface,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: user.suspend == '0'
                                ? Colors.transparent
                                : Colors.red,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return DetailUsersHanaangScreen(user: user);
                            }));
                          },
                          leading: user.image == null
                              ? CircleAvatar(
                                  backgroundColor: Theme.of(context).colorScheme.primary,
                                  child: Text(
                                    user.name![0],
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              : CircleAvatar(
                                  backgroundImage:
                                      NetworkImage("$BASE/${user.image}"),
                                ),
                          title: Text("${user.name}"),
                          subtitle: Text(
                            user.email!,
                            style: const TextStyle(fontSize: 12),
                          ),
                          trailing: PopupMenuButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              onSelected: (value) =>
                                  _handleDialogPopMenu(value, user),
                              itemBuilder: (_) {
                                return [
                                  const PopupMenuItem(
                                      value: "edit",
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Icon(Icons.edit),
                                          Text("Edit"),
                                        ],
                                      )),
                                  PopupMenuItem(
                                      value: "suspend",
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Icon(Icons.person_off,
                                              color: Theme.of(context).colorScheme.primary),
                                          Text(user.suspend == "0"
                                              ? "Suspend"
                                              : "Aktif kembali"),
                                        ],
                                      )),
                                  const PopupMenuItem(
                                      value: "hapus",
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Icon(Icons.delete, color: Colors.red),
                                          Text("Hapus"),
                                        ],
                                      )),
                                ];
                              }),
                        ),
                      );
                    },
                    separatorBuilder: (_, index) {
                      return const SizedBox(height: 3);
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("Pengguna Baru"),
        icon: const Icon(Icons.add),
        onPressed: _handleCreateNewUser,
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

    MapEntry title = data.entries.firstWhere(
      (item) =>
          item.key.toString().toLowerCase() ==
          ref.watch(roleNameUserProvider).toLowerCase(),
    );
    selectedRole = title.value;

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
                  child: Text(
                    "Tambah ${widget.title.toString().capitalize()}",
                  ),
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
                      ),
                      const SizedBox(height: 10),
                      FieldInput(
                        title: "Email",
                        hintText: "Masukkan Email",
                        controller: _emailCtrl,
                        textValidator: "",
                        keyboardType: TextInputType.text,
                        obsecureText: false,
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

  _handleSubmitCreateNew() async {
    if (_formKey.currentState!.validate()) {
      final result = await ref.watch(createUserNotifier.notifier).create(
            selectedRole!,
            name: _nameCtrl.text,
            email: _emailCtrl.text,
            phoneNumber: _phoneNumber.text,
            password: _passwordCtrl.text,
            passwordConfirmation: _passwordConfirmCtrl.text,
          );
      if (result) {
        if (!mounted) return;
        Navigator.pop(context);
        showSnackbar(
          context,
          "Berhasil tambah pengguna Baru",
        );
        clearTextEditing();
        ref.watch(userNotifier.notifier).refresh();
      } else {
        if (!mounted) return;
        Navigator.pop(context);
        showSnackbar(context, "Gagal Tambah Pengguna baru", isWarning: true);
      }
    }
  }

  _handleDialogPopMenu(value, UsersHanaang user) async {
    switch (value) {
      case 'edit':
        _dialogEditUsers(user, roleId: user.roleId);
        break;
      case "suspend":
        _dialogSuspendUsers(user);
        break;
      case "hapus":
        _dialogRemoveUsers(user);
        break;
    }
  }

  _dialogRemoveUsers(UsersHanaang user) {
    PanaraConfirmDialog.show(
      context,
      cancelButtonText: 'Kembali',
      confirmButtonText: 'Hapus',
      onTapCancel: () => Navigator.pop(context),
      onTapConfirm: () async {
        await ref.watch(usersHanaangProvider).removeUsersHanaang(user.id!);
        ref.watch(userNotifier.notifier).refresh();
        if (!mounted) return;
        Navigator.pop(context);
      },
      barrierDismissible: false,
      panaraDialogType: PanaraDialogType.error,
      message: 'Anda yakin menghapus user ini?',
    );
  }

  _dialogSuspendUsers(UsersHanaang user) {
    PanaraConfirmDialog.show(
      context,
      cancelButtonText: 'Kembali',
      confirmButtonText: user.suspend == "0" ? 'Suspend' : "Aktif",
      onTapCancel: () => Navigator.pop(context),
      onTapConfirm: () async {
        await ref.watch(usersHanaangProvider).suspendUsersHanaang(user);
        ref.watch(userNotifier.notifier).refresh();
        if (!mounted) return;
        Navigator.pop(context);
      },
      barrierDismissible: false,
      panaraDialogType: PanaraDialogType.warning,
      message:
          'Anda yakin melakukan ${user.suspend == '0' ? "suspend" : "pengaktifan"} user ini?',
    );
  }

  Future<dynamic> _dialogEditUsers(UsersHanaang user, {String? roleId}) {
    Map data = {
      "Distributor": "4b736cf3-3d81-4c39-8e44-1a7ebf16422d",
      "Agen": "52bcee5d-57ea-4037-b7cd-a8e0b3f3555f",
      "Warga": "fbf8807d-0f97-4c1a-b42f-e14d7901f9c2",
      "Keluarga": "d627b4bb-7243-49e7-913e-78e8a983c9f5",
      "Pengguna": "c1ecf558-5e51-4f40-b657-e65b54985847",
    };
    String? selected = roleId;
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                titlePadding: const EdgeInsets.all(10),
                insetPadding: const EdgeInsets.all(10),
                title:
                    const Text('Edit Jenis User', textAlign: TextAlign.center),
                content: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(2, 2),
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 5,
                      )
                    ],
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      hint: const Text("Pilih Jenis User"),
                      value: selected,
                      borderRadius: BorderRadius.circular(15),
                      isExpanded: true,
                      items: data
                          .map((key, value) {
                            return MapEntry(
                                key,
                                DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(key,
                                        textAlign: TextAlign.center)));
                          })
                          .values
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selected = value;
                        });
                      },
                    ),
                  ),
                ),
                actions: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Kembali"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await ref
                          .watch(usersHanaangProvider)
                          .editUsersHanaang(user.id!, selected);
                      if (selected == data["Distributor"]) {
                        ref
                            .watch(userDistributorNotifier.notifier)
                            .getUsersHanaang();
                      } else if (selected == data["Agen"]) {
                        ref.watch(userAgenNotifier.notifier).getUsersHanaang();
                      } else if (selected == data["Warga"]) {
                        ref.watch(userWargaNotifier.notifier).getUsersHanaang();
                      } else if (selected == data["Keluarga"]) {
                        ref
                            .watch(userFamilyNotifier.notifier)
                            .getUsersHanaang();
                      } else if (selected == data["Pengguna"]) {
                        ref.watch(newUserNotifier.notifier).getUsersHanaang();
                      }
                      switch (widget.title) {
                        case "distributor":
                          ref
                              .watch(userDistributorNotifier.notifier)
                              .getUsersHanaang();
                          break;
                        case "agen":
                          ref
                              .watch(userAgenNotifier.notifier)
                              .getUsersHanaang();
                          break;
                        case "warga":
                          ref
                              .watch(userWargaNotifier.notifier)
                              .getUsersHanaang();
                          break;
                        case "keluarga":
                          ref
                              .watch(userFamilyNotifier.notifier)
                              .getUsersHanaang();
                          break;
                        case "user":
                          ref.watch(newUserNotifier.notifier).getUsersHanaang();
                          break;
                        default:
                      }
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.green,
                          content: Text('Berhasil edit jenis user'),
                        ),
                      );
                      Navigator.pop(context);
                    },
                    child: const Text("Simpan"),
                  ),
                ],
              );
            }));
  }
}
