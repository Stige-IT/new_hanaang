import 'dart:io';

import 'package:admin_hanaang/features/bluethermal_printer/models/print_request.dart';
import 'package:admin_hanaang/features/bluethermal_printer/ui/print_view.dart';
import 'package:admin_hanaang/features/payment/provider/payment_provider.dart';
import 'package:admin_hanaang/models/order_detail.dart';
import 'package:admin_hanaang/models/payment.dart';
import 'package:admin_hanaang/utils/extensions/currency_format.dart';
import 'package:admin_hanaang/views/components/dialog_loading.dart';
import 'package:admin_hanaang/views/components/dropdown_container.dart';
import 'package:admin_hanaang/views/components/loading_in_button.dart';
import 'package:admin_hanaang/views/components/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import '../../../../features/image_picker/image_picker.dart';
import '../../../../features/order/order.dart';
import '../../../components/form_input.dart';
import '../../../components/tile_payment_detail.dart';

class DetailPaymentScreen extends ConsumerStatefulWidget {
  final OrderDetailData orderData;

  const DetailPaymentScreen(this.orderData, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DetailPaymentScreenState();
}

class _DetailPaymentScreenState extends ConsumerState<DetailPaymentScreen> {
  File? image;
  late TextEditingController _nominalCtrl;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _getData() async {
    final id = widget.orderData.orderPayment!.id;
    ref.watch(paymentNotifier.notifier).getPayment(id!, makeLoading: true);
    ref.watch(orderByIdNotifier.notifier).getOrdersById(widget.orderData.id!);
  }

  @override
  void initState() {
    Future.microtask(() => _getData());
    _nominalCtrl = TextEditingController(text: '0');
    super.initState();
  }

  Map items = {
    "Cash": "e103202b-f615-46ba-9e66-7efe8bc568b6",
    "Transfer": "a9e653ea-3a35-4473-9bb2-1fab7e67c970",
  };

  static const _locale = 'id_ID';

  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(int.parse(s));

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(paymentNotifier);
    final paymentdata = state.data;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text("Detail Pembayaran"),
      ),
      body: Stack(
        children: [
          RefreshIndicator(onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1), () {
              _getData();
            });
          }, child: Builder(builder: (_) {
            if (state.isLoading) {
              return Center(child: LoadingInButton(color: Theme.of(context).colorScheme.primary));
            } else if (state.error != null) {
              return Center(child: Text(state.error!));
            } else if (paymentdata == null || paymentdata.isEmpty) {
              return const Center(child: Text("Tidak ada Data"));
            } else {
              return _listPayment(paymentdata);
            }
          })),
          if (ref.watch(createPaymentNotifier).isLoading) const DialogLoading()
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          elevation: 2,
          onPressed: () {
            _dialogFormPaid();
            _nominalCtrl.text = "0";
            image = null;
          },
          label: const Text(
            "+ Pembayaran Baru",
            style: TextStyle(fontSize: 14),
          )),
    );
  }

  _dialogFormPaid() {
    final size = MediaQuery.of(context).size;
    final sisa = ref.watch(orderByIdNotifier).data!.orderPayment!.notYetPaid!;
    final totalPrice = int.parse(sisa).convertToIdr();
    String? methodPayment = "e103202b-f615-46ba-9e66-7efe8bc568b6";
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (_, state) {
          return AlertDialog(
            scrollable: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            insetPadding: const EdgeInsets.all(20),
            actionsPadding: const EdgeInsets.all(20),
            title: SizedBox(
                width: size.width, child: const Text("Form Pembayaran")),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownContainer(
                    title: "Metode Pembayaran",
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
                      state(() {
                        methodPayment = value;
                      });
                    },
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
                        value = _formatNumber(value.replaceAll('.', ''));
                        _nominalCtrl.value = TextEditingValue(
                          text: value,
                          selection:
                              TextSelection.collapsed(offset: value.length),
                        );
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty || value == "0") {
                        return "Harap di isi";
                      } else if (int.parse(value.replaceAll(".", "")) >
                          int.parse(sisa)) {
                        return "Nominal tidak boleh lebih dari sisa bayar";
                      }
                      return null;
                    },
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text("* Pembayaran sisa : $totalPrice")),
                  const SizedBox(height: 10),
                  ListTile(
                    title: const Text(
                      "Bukti Pembayaran",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: image == null
                        ? OutlinedButton.icon(
                            onPressed: () async => await _handleGetImage(state),
                            label: const Text("Tambahkan gambar"),
                            icon: const Icon(Icons.add),
                          )
                        : InkWell(
                            onTap: () async => await _handleGetImage(state),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: SizedBox(
                                height: 100,
                                width: double.infinity,
                                child: Image.file(image!, fit: BoxFit.cover),
                              ),
                            ),
                          ),
                  )
                ],
              ),
            ),
            actions: [
              OutlinedButton(
                onPressed: Navigator.of(context).pop,
                child: const Text("Kembali"),
              ),
              FilledButton(
                onPressed: () async {
                  final order = ref.watch(orderByIdNotifier).data;
                  if (_formKey.currentState!.validate()) {
                    Navigator.of(context).pop();
                    final paymentId = widget.orderData.orderPayment!.id!;
                    ref
                        .watch(createPaymentNotifier.notifier)
                        .createNewPayment(
                          widget.orderData.id!,
                          paymentId,
                          paymentMethodId: methodPayment!,
                          nominal: _nominalCtrl.text.replaceAll(".", ""),
                          image: image,
                        )
                        .then((succes) {
                      if (succes) {
                        // show confirm dialog for print using panaradialog confirm
                        _handlePrint(order);
                      } else {
                        showSnackbar(
                          context,
                          ref.watch(createPaymentNotifier).error!,
                          isWarning: true,
                        );
                      }
                    });
                  }
                },
                child: const Text("Tambahkan"),
              )
            ],
          );
        },
      ),
    );
  }

  _handlePrint(OrderDetailData? order) {
    final data = PrintRequest(
      id: order?.id,
      totalPrice: order?.totalPrice,
      totalQuantity: order?.totalOrder,
      price: _nominalCtrl.text.replaceAll(".", ""),
      quantity: "100",
      sisaPrice: order?.orderPayment?.notYetPaid,
      sisaQuantity: order?.orderTaking?.notYetTaken,
    );
    PanaraConfirmDialog.show(
      context,
      title: "Cetak Struk",
      message: "Apakah anda ingin mencetak struk pembayaran?",
      onTapConfirm: () {
        PrintThermal().start(order?.orderNumber, data: data).then((success) {
          Navigator.of(context).pop();
          if (success) {
            showSnackbar(context, "Berhasil mencetak struk");
          } else {
            showSnackbar(context, "Gagal mencetak struk", isWarning: true);
          }
        });
      },
      confirmButtonText: 'Cetak',
      cancelButtonText: 'Batal',
      onTapCancel: Navigator.of(context).pop,
      panaraDialogType: PanaraDialogType.normal,
    );
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
          return Column(
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
          );
        });
    if (newImage != null) {
      state(() {
        image = newImage;
      });
    }
  }

  ListView _listPayment(List<Payment> paymentdata) {
    return ListView.separated(
      itemCount: paymentdata.length,
      itemBuilder: (_, i) {
        Payment payment = paymentdata[i];
        return TilePaymentDetail(payment: payment);
      },
      separatorBuilder: (_, i) => const SizedBox(height: 7),
    );
  }
}
