part of "../penerimaan_barang.dart";

class FormPenerimaanBarangScreenAdmin extends ConsumerStatefulWidget {
  const FormPenerimaanBarangScreenAdmin({super.key});

  @override
  ConsumerState createState() => _FormPenerimaanBarangScreenAdminState();
}

class _FormPenerimaanBarangScreenAdminState
    extends ConsumerState<FormPenerimaanBarangScreenAdmin> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _totalMaterialCtrl;
  late TextEditingController _priceMaterialCtrl;

    _getData()=> ref.watch(materialsNotifier.notifier).getMaterials();

  @override
  void initState() {
    Future.microtask(() => _getData());
    _totalMaterialCtrl = TextEditingController();
    _priceMaterialCtrl = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _totalMaterialCtrl.dispose();
    _priceMaterialCtrl.dispose();
    super.dispose();
  }

  int sumTotalPrice(List<Map<String, dynamic>> data) {
    int total = 0;
    for (var item in data) {
      total += int.parse(item['price']);
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> data = ref.watch(dataNotifier);
    final state = ref.watch(materialsNotifier);
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: const EndrawerWidget(),
      appBar: AppbarAdmin(
        scaffoldKey: _scaffoldKey,
        title: "Penerimaan Barang",
      ),
      body: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
            title: const Text("Nama barang"),
            trailing: FilledButton.icon(
              onPressed: () {
                if (!state.isLoading) {
                  _dialogPenerimaanBarang();
                  _totalMaterialCtrl.text = "0";
                  _priceMaterialCtrl.clear();
                }
              },
              icon: const Icon(Icons.add),
              label: state.isLoading
                  ? const LoadingInButton()
                  : const Text("Tambah Item"),
            ),
          ),
          const Divider(thickness: 3),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(const Duration(seconds: 1), ()=> _getData());
              },
              child: ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(overscroll: false),
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0,
                      MediaQuery.of(context).viewInsets.bottom + 120),
                  itemBuilder: (_, i) {
                    Map<String, dynamic> item = data[i];
                    return Column(
                      children: [
                        ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 0),
                          title: Card(
                              child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              item['material'].name,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          )),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                        "${item["quantity"]} ${item['unit']}"),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(int.parse(item["price"])
                                        .convertToIdr()),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          onTap: () => _dialogPenerimaanBarang(data: item),
                          onLongPress: () {
                            PanaraConfirmDialog.show(
                              context,
                              message: "Yakin bahan baku ini dihapus?",
                              confirmButtonText: "Hapus",
                              cancelButtonText: "kembali",
                              onTapConfirm: () {
                                ref
                                    .watch(dataNotifier.notifier)
                                    .removeData(item["id"]);
                                Navigator.pop(context);
                              },
                              onTapCancel: Navigator.of(context).pop,
                              panaraDialogType: PanaraDialogType.error,
                            );
                          },
                        ),
                        const Divider(thickness: 2),
                      ],
                    );
                  },
                  separatorBuilder: (_, i) => const SizedBox(height: 7),
                  itemCount: data.length,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              title: const Text(
                "Total Harga",
                style: TextStyle(fontSize: 14),
              ),
              trailing: Text(
                (sumTotalPrice(data)).convertToIdr(),
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: ref.watch(createPenerimaanBarangNotifier).isLoading
                  ? () {}
                  : () {
                      if (data.isNotEmpty) {
                        List<String> materialsId = data
                            .map((item) => item['material'].id.toString())
                            .toList();

                        List<int> quantities = data
                            .map((item) => int.parse(item['quantity']))
                            .toList();

                        List<int> prices = data
                            .map((item) => int.parse(item['price']))
                            .toList();

                        PanaraConfirmDialog.show(
                          context,
                          message:
                              "Yakin menambahkan data baru ke penerimaan barang?",
                          confirmButtonText: "Simpan",
                          cancelButtonText: "Kembali",
                          onTapConfirm: () {
                            Navigator.of(context).pop();
                            ref
                                .watch(createPenerimaanBarangNotifier.notifier)
                                .createData(
                                  rawMaterialId: materialsId,
                                  prices: prices,
                                  quantities: quantities,
                                )
                                .then((value) {
                              if (value) {
                                showSnackbar(context,
                                    "Berhasil membuat data penerimaan barang ");
                                Navigator.of(context).pop();
                              } else {
                                final msg = ref
                                    .watch(createPenerimaanBarangNotifier)
                                    .error!;
                                showSnackbar(context, msg, isWarning: true);
                              }
                            });
                          },
                          onTapCancel: Navigator.of(context).pop,
                          panaraDialogType: PanaraDialogType.warning,
                        );
                      }
                    },
              child: ref.watch(createPenerimaanBarangNotifier).isLoading
                  ? const LoadingInButton()
                  : const Text("Simpan"),
            )
          ],
        ),
      ),
    );
  }

  _dialogPenerimaanBarang({Map<String, dynamic>? data}) {
    bool isShow = false;
    MaterialModel? material;
    String? unit;
    List<MaterialModel>? materials =
        ref.watch(materialsNotifier).data as List<MaterialModel>?;
    List<Map<String, dynamic>> dataTemp = ref.watch(dataNotifier);

    if (data != null) {
      isShow = true;
      _priceMaterialCtrl.text = data['price'];
      _totalMaterialCtrl.text = data['quantity'];
      material = data['material'];
      unit = data['unit'];
    }

    void increment() {
      if (_totalMaterialCtrl.text.isNotEmpty) {
        int total = int.parse(_totalMaterialCtrl.text);
        total++;
        _totalMaterialCtrl.text = total.toString();
        _priceMaterialCtrl.text =
            formatNumber((total * int.parse(material!.unitPrice!)).toString());
      } else if (_totalMaterialCtrl.text.isEmpty) {
        _totalMaterialCtrl.text = "1";
        int total = int.parse(_totalMaterialCtrl.text);
        _priceMaterialCtrl.text =
            formatNumber((total * int.parse(material!.unitPrice!)).toString());
      }
    }

    void decrement() {
      if (_totalMaterialCtrl.text.isNotEmpty) {
        int total = int.parse(_totalMaterialCtrl.text);
        if (total > 0) {
          total--;
          _totalMaterialCtrl.text = total.toString();
          _priceMaterialCtrl.text = formatNumber(
              (total * int.parse(material!.unitPrice!)).toString());
        }
      }
    }

    bool sameItem(String material) {
      for (var model in dataTemp) {
        if (model['material'].name.contains(material)) {
          return true;
        }
      }
      return false;
    }

    showDialog(
        context: context,
        builder: (_) {
          final size = MediaQuery.of(context).size;
          return StatefulBuilder(builder: (context, state) {
            return Form(
              key: _formKey,
              child: AlertDialog(
                scrollable: true,
                insetPadding: const EdgeInsets.all(20.0),
                title: Container(
                    alignment: Alignment.center,
                    width: size.width,
                    child: const Text("Pilih bahan baku")),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownContainer(
                        value: material,
                        title: "Bahan Baku",
                        items: (materials ?? [])
                            .map((e) => DropdownMenuItem(
                                value: e, child: Text(e.name ?? "")))
                            .toList(),
                        onChanged: (value) {
                          state(() {
                            material = value;
                            unit = value?.unit;
                            isShow = true;
                          });
                        }),
                    Visibility(
                      visible: isShow && material != null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: FieldInput(
                              title: "Jumlah ",
                              hintText: "0",
                              controller: _totalMaterialCtrl,
                              textValidator: "",
                              keyboardType: TextInputType.number,
                              obsecureText: false,
                              isRounded: false,
                              suffixText: unit ?? "",
                              validator: (value) {
                                if (value!.isEmpty || value == "0") {
                                  return "Harap isi";
                                }
                                return null;
                              },
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  int total = int.parse(value) *
                                      int.parse(material!.unitPrice!);
                                  _priceMaterialCtrl.text =
                                      formatNumber(total.toString());
                                }
                              },
                            ),
                          ),
                          Expanded(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                  color: Colors.red,
                                  onPressed: () {
                                    state(() {
                                      decrement();
                                    });
                                  },
                                  icon: const Icon(Icons.remove_circle)),
                              IconButton(
                                  color: Colors.green,
                                  onPressed: () {
                                    state(() {
                                      increment();
                                    });
                                  },
                                  icon: const Icon(Icons.add_circle))
                            ],
                          ))
                        ],
                      ),
                    ),
                    Visibility(
                      visible: false,
                      child: FieldInput(
                        prefixText: "Rp. ",
                        title: "Total Harga",
                        hintText: "0",
                        controller: _priceMaterialCtrl,
                        textValidator: "",
                        keyboardType: TextInputType.number,
                        obsecureText: false,
                        isRounded: false,
                        enable: false,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            value = formatNumber(value.replaceAll('.', ''));
                            _priceMaterialCtrl.value = TextEditingValue(
                              text: value,
                              selection:
                                  TextSelection.collapsed(offset: value.length),
                            );
                          }
                        },
                      ),
                    )
                  ],
                ),
                actions: [
                  OutlinedButton(
                      onPressed: Navigator.of(context).pop,
                      child: const Text("Kembali")),
                  ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate() &&
                            materials != null) {
                          final field = {
                            "id": material?.id,
                            "material": material,
                            "quantity": _totalMaterialCtrl.text,
                            "unit": unit,
                            "price":
                                _priceMaterialCtrl.text.replaceAll(".", ""),
                          };
                          log(field.toString(), name: "FIELD");
                          if (data == null) {
                            if (sameItem(
                                (field['material'] as MaterialModel).name!)) {
                              showSnackbar(context, "Bahan baku sudah ada",
                                  isWarning: true);
                            } else {
                              ref.watch(dataNotifier.notifier).addData(field);
                            }
                          } else {
                            ref
                                .watch(dataNotifier.notifier)
                                .editData(data['id'], data: field);
                          }
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text("Simpan")),
                ],
              ),
            );
          });
        });
  }
}
