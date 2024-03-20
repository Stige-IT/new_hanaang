import 'dart:io';

import 'package:admin_hanaang/features/payment/provider/payment_provider.dart';
import 'package:admin_hanaang/features/taking_order/provider/payment_provider.dart';
import 'package:admin_hanaang/models/payment.dart';
import 'package:admin_hanaang/models/taking_order.dart';
import 'package:admin_hanaang/utils/constant/base_url.dart';
import 'package:admin_hanaang/utils/extensions/currency_format.dart';
import 'package:admin_hanaang/utils/extensions/date_formater.dart';
import 'package:admin_hanaang/views/components/appbar_admin.dart';
import 'package:admin_hanaang/views/components/loading_in_button.dart';
import 'package:admin_hanaang/views/screens/admin/components/button_type.dart';
import 'package:admin_hanaang/views/screens/admin/components/endrawer/endrawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';

import '../../../../../features/image_picker/image_picker.dart';
import '../../../../../features/order/order.dart';
import '../../../../../features/user/provider/user_provider.dart';
import '../../../../../models/order_detail.dart';
import '../../../../../utils/helper/formatted_currency.dart';
import '../../../../components/form_input.dart';
import '../../../../components/snackbar.dart';

final typeHistoryNotifier =
    StateNotifierProvider<TypeHistoryNotifier, bool>((ref) {
  return TypeHistoryNotifier();
});

class TypeHistoryNotifier extends StateNotifier<bool> {
  TypeHistoryNotifier() : super(false);

  setTypeHistory(bool newValue) => state = newValue;
}

class DetailHistoryOrderScreenAO extends ConsumerStatefulWidget {
  final bool isPaymentHistory;
  final OrderDetailData orderData;

  const DetailHistoryOrderScreenAO(this.isPaymentHistory, this.orderData,
      {super.key});

  @override
  ConsumerState createState() => _DetailPaymentOrderScreenAOState();
}

class _DetailPaymentOrderScreenAOState
    extends ConsumerState<DetailHistoryOrderScreenAO> {
  late TextEditingController _nominalCtrl;
  late TextEditingController _quantityCtrl;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File? image;

  _getData() async {
    final idPaymentOrder = widget.orderData.orderPayment!.id;
    final idTakingOrder = widget.orderData.orderTaking!.id;
    ref
        .watch(typeHistoryNotifier.notifier)
        .setTypeHistory(widget.isPaymentHistory);
    ref
        .watch(paymentNotifier.notifier)
        .getPayment(idPaymentOrder!, makeLoading: true);
    ref
        .watch(takingOrderNotifier.notifier)
        .getTakingOrder(idTakingOrder!, makeLoading: true);
  }

  @override
  void initState() {
    Future.microtask(() => _getData());
    _nominalCtrl = TextEditingController(
        text: formatNumber(widget.orderData.orderPayment!.notYetPaid!));
    _quantityCtrl = TextEditingController(
        text: widget.orderData.orderTaking?.notYetTaken ?? "0");
    super.initState();
  }

  Map items = {
    "Cash": "e103202b-f615-46ba-9e66-7efe8bc568b6",
    "Transfer": "a9e653ea-3a35-4473-9bb2-1fab7e67c970",
  };

  @override
  Widget build(BuildContext context) {
    final isHistoryPayment = ref.watch(typeHistoryNotifier);
    final state = ref.watch(paymentNotifier);
    final paymentsData = state.data;
    final stateTaking = ref.watch(takingOrderNotifier);
    final takingOrderData = stateTaking.data;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppbarAdmin(
        title: isHistoryPayment ? "Detail Pembayaran" : "Detail Pengambilan",
        scaffoldKey: _scaffoldKey,
      ),
      endDrawer: const EndrawerWidget(),
      body: state.isLoading || stateTaking.isLoading
          ? Center(child: LoadingInButton(color: Theme.of(context).colorScheme.primary))
          : RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(const Duration(seconds: 1), () {
                  ref.watch(userNotifierProvider.notifier).getProfile();
                  _getData();
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: ListView(
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ButtonTypeOrder(
                              title: "Pembayaran",
                              isSelected: isHistoryPayment,
                              onPressed: () {
                                ref
                                    .watch(typeHistoryNotifier.notifier)
                                    .setTypeHistory(true);
                              },
                            ),
                            ButtonTypeOrder(
                              title: "Pengambilan",
                              isSelected: !isHistoryPayment,
                              onPressed: () {
                                ref
                                    .watch(typeHistoryNotifier.notifier)
                                    .setTypeHistory(false);
                              },
                            ),
                          ],
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[400],
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
                          ),
                          onPressed: () {
                            if (isHistoryPayment) {
                              _dialogFormPaid();
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (_) =>
                                      StatefulBuilder(builder: (_, state) {
                                        return Form(
                                          key: _formKey,
                                          child: AlertDialog(
                                            scrollable: true,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            insetPadding:
                                                const EdgeInsets.all(20),
                                            actionsPadding:
                                                const EdgeInsets.all(20),
                                            title: SizedBox(
                                                width: size.width * 0.5,
                                                child: const Text(
                                                    "Pengambilan Baru")),
                                            content: _quantityTotal(state),
                                            actions: [
                                              OutlinedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    _quantityCtrl.text = '0';
                                                  },
                                                  child: const Text("Kembali")),
                                              ElevatedButton(
                                                  onPressed: _handleSubmit,
                                                  child: const Text("Simpan"))
                                            ],
                                          ),
                                        );
                                      }));
                            }
                          },
                          icon: const Icon(Icons.add),
                          label: Text(
                            isHistoryPayment
                                ? "Pembayaran Baru"
                                : "Pengambilan Baru",
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    if (isHistoryPayment)
                      PaginatedDataTable(
                        source: MyData(paymentsData, context),
                        columns: const [
                          DataColumn(label: Text('No')),
                          DataColumn(label: Text('Waktu/Tanggal')),
                          DataColumn(label: Text('Metode Pembayaran')),
                          DataColumn(label: Text('Bukti Pembayaran')),
                          DataColumn(label: Text('Nominal')),
                          DataColumn(label: Text('Admin')),
                        ],
                        columnSpacing: 0,
                        horizontalMargin: 10,
                        rowsPerPage: 10,
                        showCheckboxColumn: false,
                      )
                    else
                      PaginatedDataTable(
                        source: MyDataTakingOrder(takingOrderData, context),
                        columns: const [
                          DataColumn(label: Text('No')),
                          DataColumn(label: Text('Waktu/Tanggal')),
                          DataColumn(label: Text('Total Diambil')),
                          DataColumn(label: Text('Admin')),
                        ],
                        columnSpacing: 0,
                        horizontalMargin: 10,
                        rowsPerPage: 10,
                        showCheckboxColumn: false,
                      ),
                    const SizedBox(height: 25),
                  ],
                ),
              ),
            ),
    );
  }

  _dialogFormPaid() {
    final size = MediaQuery.of(context).size;
    final totalPrice =
        int.parse(ref.watch(orderByIdNotifier).data!.orderPayment!.notYetPaid!)
            .convertToIdr();
    String? methodPayment = "e103202b-f615-46ba-9e66-7efe8bc568b6";
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => StatefulBuilder(builder: (_, state) {
              return AlertDialog(
                scrollable: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                insetPadding: const EdgeInsets.all(20),
                actionsPadding: const EdgeInsets.all(20),
                title: SizedBox(
                    width: size.width * 0.5,
                    child: const Text("Form Pembayaran")),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                        "Metode Pembayaran",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: const [
                            BoxShadow(
                                offset: Offset(2, 2),
                                blurRadius: 2,
                                color: Colors.black12),
                          ],
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            dropdownColor: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(15),
                            isExpanded: true,
                            hint: const Text("Pilih Metode Pembayaran"),
                            value: methodPayment,
                            items: items
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
                                methodPayment = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    FieldInput(
                      prefixText: "RP. ",
                      title: "Nominal",
                      hintText: "0",
                      controller: _nominalCtrl,
                      textValidator: "",
                      keyboardType: TextInputType.number,
                      obsecureText: false,
                      onTap: () {
                        if (_nominalCtrl.text.length <= 1) {
                          _nominalCtrl.clear();
                        }
                      },
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          value = formatNumber(value.replaceAll('.', ''));
                          _nominalCtrl.value = TextEditingValue(
                            text: value,
                            selection:
                                TextSelection.collapsed(offset: value.length),
                          );
                        }
                      },
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text("* Pembayaran sisa : $totalPrice")),
                    const SizedBox(height: 10),
                    ListTile(
                      title: const Text(
                        "Bukti Pembayaran",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      subtitle: image == null
                          ? OutlinedButton.icon(
                              onPressed: () async =>
                                  await _handleGetImage(state),
                              label: const Text("Tambahkan gambar"),
                              icon: const Icon(Icons.add),
                            )
                          : InkWell(
                              onTap: () async => await _handleGetImage(state),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: SizedBox(
                                  height: 200,
                                  width: double.infinity,
                                  child: Image.file(
                                    image!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _nominalCtrl.text = '0';
                            image = null;
                          },
                          child: const Text("Kembali"),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final paymentId =
                                widget.orderData.orderPayment!.id!;
                            final result = await ref
                                .watch(createPaymentNotifier.notifier)
                                .createNewPayment(
                                  widget.orderData.id!,
                                  paymentId,
                                  paymentMethodId: methodPayment!,
                                  nominal: _nominalCtrl.text,
                                  image: image,
                                );
                            if (result) {
                              if (!mounted) return;
                              Navigator.of(context).pop();
                              showSnackbar(
                                context,
                                "Berhasil menambahkan pembayaran baru",
                              );
                              _nominalCtrl.text = '0';
                              _getData();
                            } else {
                              if (!mounted) return;
                              Navigator.of(context).pop();
                              showSnackbar(
                                context,
                                "Gagal menambahkan pembayaran baru",
                                isWarning: true,
                              );
                              _nominalCtrl.text = '0';
                              _getData();
                            }
                          },
                          child: const Text("Tambahkan"),
                        )
                      ],
                    )
                  ],
                ),
              );
            }));
  }

  _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final id = widget.orderData.orderTaking!.id;
      final result =
          await ref.watch(createTakingOrderNotifier.notifier).createTakingOrder(
                id!,
                quantity: _quantityCtrl.text,
                orderId: widget.orderData.id!,
              );
      if (result) {
        if (!mounted) return;
        Navigator.of(context).pop();
        showSnackbar(
          context,
          "Berhasil menambahkan Pengambilan baru",
        );
        _quantityCtrl.text = '0';
        _getData();
      } else {
        if (!mounted) return;
        Navigator.of(context).pop();
        showSnackbar(
          context,
          "Gagal menambahkan Pengambilan baru",
          isWarning: true,
        );
      }
    }
  }

  Column _quantityTotal(void Function(void Function()) state) {
    final quantityTotal =
        ref.watch(orderByIdNotifier).data!.orderTaking!.notYetTaken;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text("Jumlah pengambilan : "),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _quantityCtrl,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        hintText: "0",
                        suffix: Text('/ ${quantityTotal ?? 0} Cup'),
                      ),
                      onTap: () {
                        if (_quantityCtrl.text.length <= 1) {
                          _quantityCtrl.clear();
                        }
                      },
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          if (int.parse(value) > int.parse(quantityTotal!)) {
                            _quantityCtrl.text = quantityTotal;
                          }
                        }
                      },
                      validator: (value) {
                        if (value!.isEmpty || value == '0') {
                          return "Harap Isi";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () => _handleQuantity(false, state),
              icon: const Icon(Icons.remove_circle),
            ),
            IconButton(
              onPressed: () => _handleQuantity(true, state),
              icon: const Icon(Icons.add_circle),
            )
          ],
        ),
      ],
    );
  }

  _handleQuantity(bool isIsncrement, void Function(void Function()) state) {
    int quantity = int.parse(_quantityCtrl.text);
    final quantityTotal =
        int.parse(ref.watch(orderByIdNotifier).data!.orderTaking!.notYetTaken!);
    state(() {
      if (isIsncrement && quantity < quantityTotal) {
        quantity++;
      } else if (!isIsncrement && quantity > 0) {
        quantity--;
      }
      _quantityCtrl.text = quantity.toString();
    });
  }

  _handleGetImage(void Function(void Function()) state) async {
    File? newImage;
    await showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        )),
        context: context,
        builder: (_) {
          return Padding(
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () async {
                    newImage = await ref
                        .watch(imagePickerProvider.notifier)
                        .getFromGallery(source: ImageSource.camera);
                    if (!mounted) return;
                    Navigator.pop(context);
                  },
                  leading: const Icon(Icons.camera_alt),
                  title: const Text("Kamera"),
                ),
                ListTile(
                  onTap: () async {
                    newImage = await ref
                        .watch(imagePickerProvider.notifier)
                        .getFromGallery(source: ImageSource.gallery);
                    if (!mounted) return;
                    Navigator.pop(context);
                  },
                  leading: const Icon(Icons.image),
                  title: const Text("Galeri"),
                ),
              ],
            ),
          );
        });
    if (newImage != null) {
      state(() {
        image = newImage;
      });
    }
  }
}

class MyData extends DataTableSource {
  final List<Payment>? data;
  final BuildContext context;

  MyData(this.data, this.context);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data?.length ?? 0;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    return DataRow(
        selected: index % 2 == 0,
        onSelectChanged: (value) {
          // nextPage(context, "${AppRoutes.ao}/order-detail", argument: data![index]);
        },
        cells: [
          DataCell(Text((index + 1).toString())),
          DataCell(
            Text(data![index].createdAt.toString().timeFormat()),
          ),
          DataCell(Text("${data![index].paymentMethodId}")),
          DataCell(
            data![index].proofOfPayment == null
                ? const Text("-")
                : GestureDetector(
                    onTap: () {
                      Size size = MediaQuery.of(context).size;
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                elevation: 0,
                                backgroundColor: Colors.transparent,
                                titleTextStyle:
                                    const TextStyle(color: Colors.white),
                                insetPadding: EdgeInsets.zero,
                                content: SizedBox(
                                  width: size.width,
                                  child: PhotoView(
                                    backgroundDecoration: const BoxDecoration(
                                        color: Colors.transparent),
                                    imageProvider: NetworkImage(
                                      "$BASE/${data![index].proofOfPayment}",
                                    ),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("kembali",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        )),
                                  ),
                                ],
                              ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.network(
                          "$BASE/${data![index].proofOfPayment!}",
                          height: 100),
                    ),
                  ),
          ),
          DataCell(Text("${int.parse(data![index].nominal!).convertToIdr()}")),
          DataCell(Text("${data![index].createdBy!.name}")),
        ]);
  }
}

class MyDataTakingOrder extends DataTableSource {
  final List<TakingOrder>? data;
  final BuildContext context;

  MyDataTakingOrder(this.data, this.context);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data?.length ?? 0;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    return DataRow(
        selected: index % 2 == 0,
        onSelectChanged: (value) {
          // nextPage(context, "${AppRoutes.ao}/order-detail", argument: data![index]);
        },
        cells: [
          DataCell(Text((index + 1).toString())),
          DataCell(
            Text(data![index].createdAt.toString().timeFormat()),
          ),
          DataCell(Text("${data![index].quantity} Cup")),
          DataCell(Text("${data![index].createdBy!.name}")),
        ]);
  }
}
