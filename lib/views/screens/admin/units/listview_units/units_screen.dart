part of "../unit.dart";

class UnitsScreenAdmin extends ConsumerStatefulWidget {
  const UnitsScreenAdmin({super.key});

  @override
  ConsumerState createState() => _UnitsScreenAdminState();
}

class _UnitsScreenAdminState extends ConsumerState<UnitsScreenAdmin> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TextEditingController _unitctrl;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _unitctrl = TextEditingController();
    Future.microtask(() => ref.watch(unitsNotifier.notifier).getUnits());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(unitsNotifier);
    final units = state.data;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: const EndrawerWidget(),
      appBar: AppbarAdmin(
        isMain: true,
        scaffoldKey: _scaffoldKey,
        title: "Satuan Unit",
      ),
      body: RefreshIndicator(onRefresh: () async {
        ref.watch(unitsNotifier.notifier).getUnits();
      }, child: Builder(builder: (_) {
        if (state.isLoading) {
          return Center(child: LoadingInButton(color: Theme.of(context).colorScheme.primary));
        } else if (state.error != null) {
          return Center(child: Text(state.error!));
        } else if (state.data == null || state.data!.isEmpty) {
          return const Center(child: Text("Data tidak ditemukan"));
        } else {
          return Wrap(
            children: (units ?? []).map((unit) {
              return SizedBox(
                width: size.width * 0.3,
                child: Card(
                  color: Theme.of(context).colorScheme.surface,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: ListTile(
                    leading: const Icon(Icons.abc),
                    title: const Text(
                      "Nama Satuan",
                      style: TextStyle(fontSize: 14),
                    ),
                    subtitle: Text(
                      unit.name!,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    trailing: PopupMenuButton(
                      onSelected: (value) =>
                          _handlePopMenuButton(value, unit),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      itemBuilder: (BuildContext context) {
                        return [
                          PopupMenuItem(
                              value: "edit",
                              child: ListTile(
                                dense: true,
                                leading: Icon(
                                  Icons.edit,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                title: const Text("Edit"),
                              )),
                          const PopupMenuItem(
                              value: "delete",
                              child: ListTile(
                                dense: true,
                                leading: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                title: Text("Hapus"),
                              )),
                        ];
                      },
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        }
      })),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _dialogFormUnit(),
        label: const Text("Tambah Unit"),
        icon: const Icon(Icons.add),
      ),
    );
  }

  _dialogFormUnit({UnitModel? unit}) {
    _unitctrl.clear();
    if (unit != null) {
      _unitctrl.text = unit.name!;
    }
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Form Unit'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FieldInput(
                  hintText: "Masukkan Unit satuan",
                  controller: _unitctrl,
                  textValidator: "",
                  keyboardType: TextInputType.text,
                  obsecureText: false,
                  isRounded: false,
                )
              ],
            ),
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.of(context).pop();
                    if (unit == null) {
                      ref
                          .watch(createUnitNotifier.notifier)
                          .createUnit(name: _unitctrl.text)
                          .then((succes) {
                        if (succes) {
                          showSnackbar(context, "Berhasil tambah unit");
                        } else {
                          final msgError =
                          ref.watch(createUnitNotifier).error!;
                          showSnackbar(context, msgError, isWarning: true);
                        }
                      });
                    } else {
                      ref
                          .watch(updateUnitNotifier.notifier)
                          .updateUnit(unit.id!, name: _unitctrl.text)
                          .then((succes) {
                        if (succes) {
                          showSnackbar(
                              context, "Berhasil memperbaharui unit");
                        } else {
                          final msgError =
                          ref.watch(updateUnitNotifier).error!;
                          showSnackbar(context, msgError, isWarning: true);
                        }
                      });
                    }
                  }
                },
                child: const Text("Simpan")),
          ],
        ));
  }

  _handlePopMenuButton(value, UnitModel unit) {
    switch (value) {
      case "edit":
        _dialogFormUnit(unit: unit);
        break;
      case "delete":
        PanaraConfirmDialog.show(
          context,
          message: "Yakin Hapus Unit Satuan Ini?",
          confirmButtonText: "Hapus",
          cancelButtonText: "Kembali",
          onTapConfirm: () {
            Navigator.of(context).pop();
            ref
                .watch(deleteUnitNotifier.notifier)
                .deleteeUnit(unit.id!)
                .then((succes) {
              if (succes) {
                showSnackbar(context, "Berhasil Hapus Unit");
              } else {
                final message = ref.watch(deleteUnitNotifier).error;
                showSnackbar(context, message!, isWarning: true);
              }
            });
          },
          onTapCancel: Navigator.of(context).pop,
          panaraDialogType: PanaraDialogType.error,
        );
        break;
      default:
    }
  }
}
