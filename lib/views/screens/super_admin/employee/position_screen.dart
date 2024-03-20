import 'package:admin_hanaang/features/position/provider/order_provider.dart';
import 'package:admin_hanaang/models/position.dart';
import 'package:admin_hanaang/views/components/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

class PositionScreen extends ConsumerStatefulWidget {
  const PositionScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PositionScreenState();
}

class _PositionScreenState extends ConsumerState<PositionScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _positionCtrl;
  @override
  void initState() {
    _positionCtrl = TextEditingController();
    Future.microtask(() => ref.watch(positionNotifier.notifier).getPostions());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(positionNotifier);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text("Jabatan"),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(const Duration(seconds: 1), () {
                  ref.watch(positionNotifier.notifier).getPostions();
                });
              },
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 70.0),
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (_, i) {
                  Position position = state.data![i];
                  return ListTile(
                    title: Text("${position.name}"),
                    subtitle: const Divider(thickness: 2),
                    trailing: PopupMenuButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onSelected: (value) {
                          switch (value) {
                            case 'edit':
                              _dialogPosition(position: position);
                              break;
                            case "delete":
                              _dialogDeletePosition(position);
                              break;
                            default:
                          }
                        },
                        itemBuilder: (_) {
                          return [
                            const PopupMenuItem(
                                value: "edit", child: Text("Edit")),
                            const PopupMenuItem(
                                value: "delete", child: Text("Hapus")),
                          ];
                        }),
                  );
                },
                separatorBuilder: (_, i) {
                  return const SizedBox(height: 5);
                },
                itemCount: state.data?.length ?? 0,
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _dialogPosition(),
        label: const Text("Tambah Jabatan"),
        icon: const Icon(Icons.add),
      ),
    );
  }

  _dialogDeletePosition(Position position) {
    PanaraConfirmDialog.show(context,
        message: "Yakin menghapus Jabatan?",
        confirmButtonText: "Hapus",
        cancelButtonText: "Kembali", onTapConfirm: () {
      ref
          .watch(positionNotifier.notifier)
          .deletePosition(positionId: position.id!)
          .then((value) {
        if (value) {
          Navigator.pop(context);
        }
      });
    },
        onTapCancel: Navigator.of(context).pop,
        panaraDialogType: PanaraDialogType.error);
  }

  _dialogPosition({Position? position}) {
    _positionCtrl.clear();
    if (position != null) {
      _positionCtrl.text = position.name!;
    }
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text("Data Jabatan"),
              content: Form(
                key: _formKey,
                child: TextFormField(
                  controller: _positionCtrl,
                  decoration: const InputDecoration(
                      hintText: "Masukkan Jabatan",
                      enabledBorder: OutlineInputBorder(),
                      border: OutlineInputBorder()),
                ),
              ),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (position == null) {
                          ref
                              .watch(positionNotifier.notifier)
                              .createPostions(name: _positionCtrl.text)
                              .then((value) {
                            if (value) {
                              showSnackbar(
                                  context, "Berhasil menambah jabatan");
                            } else {
                              showSnackbar(context, "Gagal menambahkan Jabatan",
                                  isWarning: true);
                            }
                            Navigator.pop(context);
                          });
                        } else {
                          ref
                              .watch(positionByIdNotifier.notifier)
                              .updatePostions(position.id!,
                                  name: _positionCtrl.text)
                              .then((value) {
                            if (value) {
                              ref
                                  .watch(positionNotifier.notifier)
                                  .getPostions();
                              showSnackbar(
                                  context, "Berhasil memperbaharui jabatan");
                            } else {
                              showSnackbar(
                                  context, "Gagal memperbaharui Jabatan",
                                  isWarning: true);
                            }
                            Navigator.pop(context);
                          });
                        }
                      }
                    },
                    child: const Text("Simpan"))
              ],
            ));
  }
}
