import 'package:admin_hanaang/features/material/provider/material_provider.dart';
import 'package:admin_hanaang/features/suplayer/provider/suplayer_provider.dart';
import 'package:admin_hanaang/features/unit/provider/unit_provider.dart';
import 'package:admin_hanaang/models/unit.dart';
import 'package:admin_hanaang/utils/helper/formatted_currency.dart';
import 'package:admin_hanaang/views/components/dropdown_container.dart';
import 'package:admin_hanaang/views/components/form_input.dart';
import 'package:admin_hanaang/views/components/loading_in_button.dart';
import 'package:admin_hanaang/views/components/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FormMaterialScreen extends ConsumerStatefulWidget {
  const FormMaterialScreen({super.key});

  @override
  ConsumerState createState() => _FormMaterialScreenState();
}

class _FormMaterialScreenState extends ConsumerState<FormMaterialScreen> {
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
    Future.microtask(() {
      _getData();
    });
    _nameCtrl = TextEditingController();
    _totalCtrl = TextEditingController();
    _priceCtrl = TextEditingController();
    _unitCtrl = TextEditingController();
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text("Tambah Bahan Baku"),
      ),
      body: Form(
        key: _formKey,
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1), () {
              _getData();
            });
          },
          child: ListView(
            padding: const EdgeInsets.all(15.0),
            children: [
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
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
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
                  },
                  child: state.isLoading
                      ? const LoadingInButton()
                      : const Text("Simpan")),
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