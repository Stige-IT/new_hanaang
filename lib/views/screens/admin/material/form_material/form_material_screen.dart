part of "../material.dart";

class FormMaterialScreenAdmin extends ConsumerStatefulWidget {
  final MaterialModel? material;

  const FormMaterialScreenAdmin({super.key, this.material});

  @override
  ConsumerState createState() => _FormMaterialScreenAdminiState();
}

class _FormMaterialScreenAdminiState
    extends ConsumerState<FormMaterialScreenAdmin> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameCtrl;
  late TextEditingController _totalCtrl;
  late TextEditingController _priceCtrl;
  late TextEditingController _unitCtrl;

  _getData() async {
    ref.watch(unitsNotifier.notifier).getUnits();
    ref.watch(suplayerNotifier.notifier).getSuplayer();
  }

  @override
  void initState() {
    Future.microtask(() => _getData());
    _nameCtrl = TextEditingController();
    _totalCtrl = TextEditingController();
    _priceCtrl = TextEditingController();
    _unitCtrl = TextEditingController();
    if (widget.material != null) {
      _nameCtrl.text = widget.material!.name!;
      _priceCtrl.text = widget.material!.unitPrice!;
    }
    super.initState();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _totalCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stateUnit = ref.watch(createUnitNotifier);
    final units = ref.watch(unitsNotifier).data;
    final state = ref.watch(createMaterialNotifier);
    final suplayers = ref.watch(suplayerNotifier).data;
    final valueSuplayer = ref.watch(dropdownValueSuplayer);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppbarAdmin(scaffoldKey: _scaffoldKey, title: "Form Bahan Baku"),
      endDrawer: const EndrawerWidget(),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1), () {
            _getData();
          });
        },
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.25, vertical: 15.0),
            children: [
              if (widget.material == null)
                DropdownContainer<String>(
                    value: ref.watch(dropdownValueSuplayer),
                    title: "Suplayer",
                    items: (suplayers ?? [])
                        .map(
                          (e) => DropdownMenuItem<String>(
                            value: e.id,
                            child: Text(e.name!),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      ref.watch(dropdownValueSuplayer.notifier).state = value!;
                    }),
              FieldInput(
                title: "Nama Bahan Baku",
                hintText: "Masukkan Nama Bahan Baku",
                controller: _nameCtrl,
                textValidator: "",
                keyboardType: TextInputType.text,
                obsecureText: false,
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: DropdownContainer<UnitModel>(
                      title: "Jenis Unit",
                      value: ref.watch(dropdownValueUnit),
                      items: (units ?? [])
                          .map(
                            (e) => DropdownMenuItem<UnitModel>(
                              value: e,
                              child: Text(e.name!),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        ref.watch(dropdownValueUnit.notifier).state = value!;
                      },
                    ),
                  ),
                  Expanded(
                      child: stateUnit.isLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : OutlinedButton.icon(
                              onPressed: () {
                                _unitCtrl.clear();
                                _handleCreateUnit();
                              },
                              icon: const Icon(Icons.add),
                              label: const Text("Tambah unit baru"),
                            ))
                ],
              ),
              const SizedBox(height: 10),
              if (widget.material == null)
                FieldInput(
                  title: "Jumlah Bahan Baku",
                  hintText: "Masukan Jumlah",
                  suffixText: ref.watch(dropdownValueUnit)?.name ?? "",
                  controller: _totalCtrl,
                  textValidator: "",
                  keyboardType: TextInputType.number,
                  obsecureText: false,
                ),
              const SizedBox(height: 10),
              FieldInput(
                prefixText: "Rp. ",
                title: "Harga Per-satuan",
                hintText: "Masukan Harga",
                controller: _priceCtrl,
                textValidator: "",
                keyboardType: TextInputType.number,
                obsecureText: false,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    value = formatNumber(value.replaceAll('.', ''));
                    _priceCtrl.value = TextEditingValue(
                      text: value,
                      selection: TextSelection.collapsed(offset: value.length),
                    );
                  }
                },
                validator: (value) {
                  if (value!.isEmpty || value == "0") {
                    return "Harap isi";
                  } else if (ref.watch(dropdownValueUnit) == null) {
                    return "Harap pilih unit satuan";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (widget.material != null) {
                      ref
                          .read(updateMaterialNotifier.notifier)
                          .updateMaterial(
                            widget.material!.id!,
                            name: _nameCtrl.text,
                            unitId: ref.watch(dropdownValueUnit)!.id!,
                            unitPrice: _priceCtrl.text.replaceAll(".", ""),
                          )
                          .then((success) {
                        if (success) {
                          Navigator.of(context).pop();
                        }else{
                          final err = ref.watch(updateMaterialNotifier).error;
                          showSnackbar(context, err!, isWarning: true);
                        }
                      });
                    } else {
                      ref
                          .watch(createMaterialNotifier.notifier)
                          .createMaterial(
                            suplayerId: valueSuplayer!,
                            name: _nameCtrl.text,
                            unitId: ref.watch(dropdownValueUnit)!.id!,
                            stock: _totalCtrl.text,
                            unitPrice: _priceCtrl.text.replaceAll(".", ""),
                          )
                          .then((value) {
                        if (value) {
                          Navigator.of(context).pop();
                          showSnackbar(
                              context, "Berhasil menambahkan bahan baku");
                        } else {
                          showSnackbar(context, "Gagal menambahkan bahan baku",
                              isWarning: true);
                        }
                      });
                    }
                  }
                },
                child: state.isLoading || ref.watch(updateMaterialNotifier).isLoading
                    ? const LoadingInButton()
                    : const Text("Simpan"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _handleCreateUnit() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text("Tambah unit"),
              content: TextField(
                controller: _unitCtrl,
                decoration: const InputDecoration(
                    hintText: "Masukkan Unit",
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder()),
              ),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      ref
                          .watch(createUnitNotifier.notifier)
                          .createUnit(name: _unitCtrl.text)
                          .then((value) {
                        if (value) {
                          ref.invalidate(dropdownValueUnit);
                          ref.watch(unitsNotifier.notifier).getUnits();
                          showSnackbar(context, "Berhasil menambahkan Unit");
                        } else {
                          showSnackbar(context, "Gagal menambahkan Unit",
                              isWarning: true);
                        }
                      });
                    },
                    child: const Text("Simpan"))
              ],
            ));
  }
}
