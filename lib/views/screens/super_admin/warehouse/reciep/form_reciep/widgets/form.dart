part of "../../reciep.dart";

class FormRecipt extends ConsumerStatefulWidget {
  final ItemRecipt? items;
  final PageController _pageController;
  const FormRecipt(this._pageController, {super.key, this.items});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FormReciptState();
}

class _FormReciptState extends ConsumerState<FormRecipt> {
  late TextEditingController _totalMaterialCtrl;
  late TextEditingController _totalCtrl;

  @override
  void initState() {
    Future.microtask(() async {
      ref.watch(materialsNotifier.notifier).getMaterials();
    });
    _totalMaterialCtrl = TextEditingController();
    _totalCtrl = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _totalMaterialCtrl.dispose();
    _totalCtrl.dispose();
    super.dispose();
  }

  void increment(MaterialModel? material) {
    if (_totalMaterialCtrl.text.isNotEmpty) {
      int total = int.parse(_totalMaterialCtrl.text);
      if (material != null && total < int.parse(material.stock!)) {
        total++;
        _totalMaterialCtrl.text = total.toString();
      }
    }
  }

  void decrement() {
    if (_totalMaterialCtrl.text.isNotEmpty) {
      int total = int.parse(_totalMaterialCtrl.text);
      if (total > 0) {
        total--;
        _totalMaterialCtrl.text = total.toString();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final materials = ref.watch(materialsNotifier).data as List<MaterialModel>?;
    final selectedMaterial = ref.watch(selectMaterialProvider);
    final dataTemporary = ref.watch(dataItemNotifier);
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0),
      child: Column(
        children: [
          ListTile(
            visualDensity: const VisualDensity(vertical: -3),
            contentPadding: EdgeInsets.zero,
            title: Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                onPressed: () {
                  widget._pageController.animateToPage(
                    0,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.bounceIn,
                  );
                },
                icon: const Icon(Icons.arrow_back_ios_rounded),
                label: const Text("Kembali"),
              ),
            ),
            trailing: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        title: const Text("Estimasi jumlah Produk"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FieldInput(
                              title: "Jumlah Produk",
                              hintText: "Masukkan Jumlah",
                              controller: _totalCtrl,
                              textValidator: "",
                              keyboardType: TextInputType.number,
                              obsecureText: false,
                              isRounded: false,
                              suffixText: " /Cup",
                            ),
                          ],
                        ),
                        actions: [
                          OutlinedButton(
                            onPressed: Navigator.of(context).pop,
                            child: const Text("Kembali"),
                          ),
                          FilledButton(
                            onPressed: () => _handleSubmitItemRecipt(),
                            child: const Text("Simpan"),
                          )
                        ],
                      );
                    });
              },
              child: const Text("Simpan"),
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownContainer(
                    title: "Bahan Baku",
                    value: selectedMaterial,
                    items: (materials ?? [])
                        .map((material) => DropdownMenuItem(
                            value: material, child: Text(material.name!)))
                        .toList(),
                    onChanged: (value) {
                      _totalMaterialCtrl.text = "0";
                      ref.read(selectMaterialProvider.notifier).state = value;
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: FieldInput(
                          title: "Jumlah ",
                          hintText: "0",
                          controller: _totalMaterialCtrl,
                          textValidator: "",
                          keyboardType: TextInputType.number,
                          obsecureText: false,
                          isRounded: false,
                          suffixText: selectedMaterial != null
                              ? " / ${selectedMaterial.stock} ${selectedMaterial.unit}"
                              : null,
                          onChanged: (value) {
                            if (value.isNotEmpty && selectedMaterial != null) {
                              final stock = int.parse(selectedMaterial.stock!);
                              int total = int.parse(value.replaceAll(".", ""));
                              if (total > stock) {
                                _totalMaterialCtrl.text = stock.toString();
                              }
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
                              onPressed: () => decrement(),
                              icon: const Icon(Icons.remove_circle)),
                          IconButton(
                              color: Colors.green,
                              onPressed: () => increment(selectedMaterial),
                              icon: const Icon(Icons.add_circle))
                        ],
                      ))
                    ],
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _handleAddDataToTemporary,
                    child: const Text("Simpan"),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // listItem of Form
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Daftar Item",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Builder(builder: (context) {
              if (dataTemporary.isEmpty) {
                return const EmptyWidget();
              }
              return ListView.separated(
                padding: const EdgeInsets.only(bottom: 30.0),
                itemBuilder: (_, i) {
                  ItemMaterial data = dataTemporary[i];
                  return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        // onTap: () {
                        //   _totalMaterialCtrl.text = data.quantity.toString();
                        //   ref.read(selectMaterialProvider.notifier).state =
                        //       data.material;
                        // },
                        leading: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black,
                          child: Text("${i + 1}"),
                        ),
                        title: Text(data.material!.name ?? "-",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            )),
                        subtitle:
                            Text("${data.quantity} ${data.material!.unit}",
                                style: const TextStyle(
                                  color: Colors.black,
                                )),
                        trailing: IconButton(
                            onPressed: () {
                              ref
                                  .read(dataItemNotifier.notifier)
                                  .removeData(data.id!);
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            )),
                      ));
                },
                separatorBuilder: (_, i) => const SizedBox(height: 5),
                itemCount: dataTemporary.length,
              );
            }),
          )
        ],
      ),
    );
  }

  _handleSubmitItemRecipt() {
    final dataTemporary = ref.watch(dataItemNotifier);
    Navigator.of(context).pop();
    if (dataTemporary.isNotEmpty) {
      ItemRecipt itemRecipt = ItemRecipt(
        id: Random().nextInt(1000).toString(),
        recipe: Recipe(
          recipeItem: dataTemporary.map((e) => e.material!).toList(),
          productEstimation: int.parse(_totalCtrl.text),
        ),
      );
      ref.read(dataNotifier.notifier).addData(itemRecipt);

      widget._pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.bounceIn,
      );
    } else {
      showSnackbar(context, "Pilih terlebih dahulu bahan baku",
          isWarning: true);
    }
  }

  bool _sameItemInTemporary(MaterialModel material) {
    final data = ref.watch(dataItemNotifier);
    for (ItemMaterial item in data) {
      if (item.material?.id == material.id) {
        return true;
      }
    }
    return false;
  }

  _handleAddDataToTemporary() {
    final selectedMaterial = ref.watch(selectMaterialProvider);
    if (selectedMaterial != null) {
      if (_sameItemInTemporary(selectedMaterial)) {
        showSnackbar(context, "Bahan baku sudah di pilih", isWarning: true);
      } else {
        ItemMaterial item = ItemMaterial(
          id: Random().nextInt(1000).toString(),
          quantity: int.parse(_totalMaterialCtrl.text),
          material: selectedMaterial,
        );
        ref.read(dataItemNotifier.notifier).addData(item);
        _totalMaterialCtrl.text = "0";
        ref.invalidate(selectMaterialProvider);
      }
    }
  }
}
