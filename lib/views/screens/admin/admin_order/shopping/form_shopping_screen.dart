import 'dart:math';

import 'package:admin_hanaang/features/shopping/provider/shopping_provider.dart';
import 'package:admin_hanaang/models/shopping.dart';
import 'package:admin_hanaang/utils/extensions/currency_format.dart';
import 'package:admin_hanaang/utils/helper/formatted_currency.dart';
import 'package:admin_hanaang/views/components/appbar_admin.dart';
import 'package:admin_hanaang/views/components/dialog_loading.dart';
import 'package:admin_hanaang/views/components/form_input.dart';
import 'package:admin_hanaang/views/components/snackbar.dart';
import 'package:admin_hanaang/views/screens/admin/components/endrawer/endrawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FormShoppingScreenAO extends ConsumerStatefulWidget {
  const FormShoppingScreenAO({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FormShoppingScreenAOState();
}

class _FormShoppingScreenAOState extends ConsumerState<FormShoppingScreenAO> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _quantityCtrl;
  late TextEditingController _priceCtrl;

  @override
  void initState() {
    _nameCtrl = TextEditingController();
    _quantityCtrl = TextEditingController();
    _priceCtrl = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _quantityCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  clearTextEditing() {
    _nameCtrl.clear();
    _priceCtrl.clear();
    _quantityCtrl.clear();
  }

  String totalPrice() {
    int total = 0;
    if (_quantityCtrl.text.isNotEmpty && _priceCtrl.text.isNotEmpty) {
      int quantity = int.parse(_quantityCtrl.text.replaceAll(".", ""));
      int price = int.parse(_priceCtrl.text.replaceAll(".", ""));
      total = quantity * price;
    }
    return formatNumber(total.toString());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final items = ref.watch(cartShoppingNotifier);
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: const EndrawerWidget(),
      appBar: AppbarAdmin(scaffoldKey: _scaffoldKey, title: "Pengeluaran"),
      body: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(15.0),
                  width: size.width * 0.4,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const ListTile(
                          title: Text(
                            "Formulir pengeluaran",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                        ),
                        FieldInput(
                          title: "Nama barang",
                          hintText: "Masukkan Nama barang",
                          controller: _nameCtrl,
                          textValidator: "",
                          keyboardType: TextInputType.text,
                          obsecureText: false,
                        ),
                        FieldInput(
                          title: "Jumlah",
                          hintText: "Masukkan jumlah barang",
                          controller: _quantityCtrl,
                          textValidator: "",
                          keyboardType: TextInputType.number,
                          obsecureText: false,
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              value = formatNumber(value.replaceAll(".", ""));
                              _quantityCtrl.value = TextEditingValue(
                                text: value,
                                selection: TextSelection.collapsed(
                                    offset: value.length),
                              );
                            }
                          },
                        ),
                        FieldInput(
                          prefixText: "Rp. ",
                          title: "harga satuan",
                          hintText: "Masukkan harga barang",
                          controller: _priceCtrl,
                          textValidator: "",
                          keyboardType: TextInputType.number,
                          obsecureText: false,
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              value = formatNumber(value.replaceAll(".", ""));
                              _priceCtrl.value = TextEditingValue(
                                text: value,
                                selection: TextSelection.collapsed(
                                    offset: value.length),
                              );
                            }
                          },
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          visualDensity: const VisualDensity(horizontal: -3),
                          title: const Text(
                            "Total Harga",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: const Text("Harga satuan x jumlah",
                              style: TextStyle(fontSize: 12)),
                          trailing: Text("Rp.${totalPrice()}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        SizedBox(height: size.height * 0.05),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final item = ShoppingItem(
                                id: Random().nextInt(1000).toString(),
                                name: _nameCtrl.text,
                                quantity:
                                    _quantityCtrl.text.replaceAll(".", ""),
                                price: _priceCtrl.text.replaceAll(".", ""),
                                totalPrice: totalPrice().replaceAll(".", ""),
                              );
                              ref
                                  .read(cartShoppingNotifier.notifier)
                                  .addItem(item);
                              clearTextEditing();
                            }
                          },
                          child: const Text("Tambah"),
                        )
                      ],
                    ),
                  ),
                ),
              ),

              const VerticalDivider(thickness: 2),

              //data table shoppings
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ListTile(
                        title: const Text(
                          "Daftar pengeluaran",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        trailing: RichText(
                          text: TextSpan(
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 16),
                              children: [
                                const TextSpan(text: "Jumlah : "),
                                TextSpan(
                                    text: "${items.length}",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    )),
                                const TextSpan(text: " Barang"),
                              ]),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.7,
                        child: Card(
                          elevation: 2,
                          child: SingleChildScrollView(
                            child: DataTable(
                              columnSpacing: 0,
                              showBottomBorder: true,
                              columns: const [
                                DataColumn(label: Text("No")),
                                DataColumn(label: Text("Nama barang")),
                                DataColumn(label: Text("Jumlah")),
                                DataColumn(label: Text("Harga")),
                                DataColumn(label: Text("Total Harga")),
                                DataColumn(label: Text("Aksi")),
                              ],
                              rows: [
                                for (int i = 0; i < items.length; i++)
                                  DataRow(
                                    selected: i % 2 == 0,
                                    cells: [
                                      DataCell(Text("${i + 1}")),
                                      DataCell(Text(items[i].name ?? "-")),
                                      DataCell(Text(items[i].quantity ?? "0")),
                                      DataCell(Text(
                                        int.parse(items[i].price ?? "0")
                                            .convertToIdr(),
                                      )),
                                      DataCell(Text(
                                        int.parse(items[i].totalPrice ?? "0")
                                            .convertToIdr(),
                                      )),
                                      DataCell(IconButton(
                                          onPressed: () {
                                            ref
                                                .read(cartShoppingNotifier
                                                    .notifier)
                                                .removeItem(items[i].id!);
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ))),
                                    ],
                                  )
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),
                        onPressed: () => _handleSaveDataShopping(items),
                        child: const Text("Simpan"),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          if (ref.watch(createShoppingNotifier).isLoading) const DialogLoading()
        ],
      ),
    );
  }

  _handleSaveDataShopping(List<ShoppingItem> items) {
    if (items.isNotEmpty || !ref.watch(createShoppingNotifier).isLoading) {
      List<String> names = items.map((item) => item.name!).toList();
      List<int> quantities =
          items.map((item) => int.parse(item.quantity!)).toList();
      List<int> prices =
          items.map((item) => int.parse(item.totalPrice!)).toList();
      ref
          .read(createShoppingNotifier.notifier)
          .create(
            itemsName: names,
            quantities: quantities,
            prices: prices,
          )
          .then((success) {
        if (success) {
          Navigator.of(context).pop();
          showSnackbar(context, "Berhasil simpan pengeluaran baru");
        } else {
          final errorMsg = ref.watch(createShoppingNotifier).error;
          showSnackbar(context, errorMsg!, isWarning: true);
        }
      });
    }
  }
}
