import 'package:admin_hanaang/utils/extensions/date_formater.dart';
import 'package:admin_hanaang/utils/helper/formatted_currency.dart';
import 'package:admin_hanaang/views/components/appbar_admin.dart';
import 'package:admin_hanaang/views/components/loading_in_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../features/pre-order/provider/pre_order_provider.dart';
import '../../../../../../features/stock/provider/stock_provider.dart';
import '../../../../../../models/pre_order.dart';
import '../../../../../../utils/extensions/start_to_end_time.dart';
import '../../../../../components/datetime_picker.dart';
import '../../../../../components/empty_preorder.dart';
import '../../../../../components/form_input.dart';
import '../../../../../components/snackbar.dart';
import '../../../components/endrawer/endrawer_widget.dart';

final isActiveNotifier = StateProvider<bool>((ref) => false);

class SettingPreOrderScreenAO extends ConsumerStatefulWidget {
  const SettingPreOrderScreenAO({super.key});

  @override
  ConsumerState createState() => _SettingPreOrderScreenAOState();
}

class _SettingPreOrderScreenAOState
    extends ConsumerState<SettingPreOrderScreenAO> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _totalStock;
  DateTime selectedDateStart = DateTime.now();
  DateTime selectedDateEnd = DateTime.now();
  final today = DateTime.now();

  _getData() async {
    ref.watch(remainingStockNotifier.notifier).getStock();
    await ref.watch(preOrderNotifierProvider.notifier).getPreOrder();
  }

  @override
  void initState() {
    Future.microtask(() => _getData());
    _totalStock = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(preOrderNotifierProvider, (previous, next) {
      if (next.data != null) {
        final expired = DateTime.parse(next.data!.end!);
        final startedDatetime = DateTime.parse(next.data!.start!);
        int sisa = (next.data!.sisaStockPo!);
        if (sisa == 0 ||
            expired.isBefore(today) ||
            today.isBefore(startedDatetime)) {
          /*
          label non-aktif
          - expired
          - remaining stock == 0
          - before start open pre order
          */
          ref.watch(isActiveNotifier.notifier).state = false;
          showSnackbar(context, "Pre Order Tidak Aktif", isWarning: true);
        } else {
          ref.watch(isActiveNotifier.notifier).state = true;
        }
      }
    });

    final state = ref.watch(preOrderNotifierProvider);
    final PreOrder? preOrderData = state.data;
    final isActive = ref.watch(isActiveNotifier);
    final stock = ref.watch(remainingStockNotifier).data;
    return Scaffold(
      key: _key,
      appBar: AppbarAdmin(title: "Setting Pre Order", scaffoldKey: _key),
      endDrawer: const EndrawerWidget(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1), () {
              _getData();
            });
          },
          child: ListView(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        ListTile(
                          title: const Text("Pre Order",
                              style: TextStyle(
                                fontFamily: "Kaushan",
                                fontSize: 36,
                              )),
                          trailing: Chip(
                            backgroundColor: preOrderData != null && isActive
                                ? Colors.green
                                : Colors.red,
                            label: Text(
                              preOrderData != null && isActive
                                  ? "Aktif"
                                  : "Tidak Aktif",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        if (state.isLoading)
                          Shimmer.fromColors(
                            baseColor: Colors.grey.withOpacity(0.2),
                            highlightColor: Colors.white,
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              width: double.infinity,
                              height: 140,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.grey,
                              ),
                            ),
                          )
                        else if (preOrderData != null)
                          Container(
                            height: 170,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: const DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage('assets/images/banner.png'),
                                )),
                            child: Container(
                              height: double.infinity,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.black38,
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ListTile(
                                    trailing: Text(
                                      "${formatNumber(preOrderData.sisaStockPo.toString() ?? "0")}/${formatNumber(preOrderData.stockPo.toString() ?? "0")} Cup",
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    title: const Text("Waktu :",
                                        style: TextStyle(
                                          color: Colors.white,
                                        )),
                                    subtitle: Text(
                                        timeStartToEnd(
                                          preOrderData.start!,
                                          preOrderData.end!,
                                        ),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    trailing: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(preOrderData.start!.dateFormat(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              decoration:
                                                  TextDecoration.underline,
                                            )),
                                        Text(preOrderData.end!.dateFormat(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          const EmptyPreOrder(),
                        ListTile(
                          visualDensity: const VisualDensity(vertical: -4),
                          contentPadding: EdgeInsets.zero,
                          title: const Text("Jumlah Produk :"),
                          trailing: Text(
                              "${formatNumber(preOrderData?.stockPo.toString() ?? "0")} Cup"),
                        ),
                        ListTile(
                          visualDensity: const VisualDensity(vertical: -4),
                          contentPadding: EdgeInsets.zero,
                          title: const Text("Sisa Produk :"),
                          trailing: Text(
                              "${formatNumber(preOrderData?.sisaStockPo.toString() ?? "0")} Cup"),
                        ),
                        ListTile(
                            visualDensity: const VisualDensity(vertical: -4),
                            contentPadding: EdgeInsets.zero,
                            title: const Text("Dimulai :"),
                            trailing: preOrderData == null
                                ? null
                                : Text("${preOrderData.start}".timeFormat())),
                        ListTile(
                          visualDensity: const VisualDensity(vertical: -4),
                          contentPadding: EdgeInsets.zero,
                          title: const Text("Selesai :"),
                          trailing: preOrderData == null
                              ? null
                              : Text("${preOrderData.end}".timeFormat()),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          "Setting Pre-Order",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                        const SizedBox(height: 20),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              ListTile(
                                shape: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: const BorderSide(
                                    color: Colors.orange,
                                  ),
                                ),
                                title: const Text("Tanggal & waktu mulai",
                                    style: TextStyle(
                                      fontSize: 12,
                                    )),
                                subtitle: Text(
                                    selectedDateStart.toString().timeFormat(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    )),
                                trailing: IconButton(
                                  onPressed: () async {
                                    final datetime =
                                        await DateTimePicker.showDateTimePicker(
                                            context: context,
                                            title:
                                                "Silahkan pilih tanggal dan waktu mulai");
                                    setState(() {
                                      selectedDateStart = datetime!;
                                    });
                                  },
                                  icon: const Icon(Icons.date_range),
                                ),
                              ),
                              const SizedBox(height: 20),
                              ListTile(
                                shape: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: const BorderSide(
                                    color: Colors.orange,
                                  ),
                                ),
                                title: const Text("Tanggal & waktu Selesai",
                                    style: TextStyle(
                                      fontSize: 12,
                                    )),
                                subtitle: Text(
                                    selectedDateEnd.toString().timeFormat(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    )),
                                trailing: IconButton(
                                  onPressed: () async {
                                    final datetime =
                                        await DateTimePicker.showDateTimePicker(
                                            context: context,
                                            title:
                                                "Silahkan pilih tanggal dan waktu selesai");
                                    setState(() {
                                      selectedDateEnd = datetime!;
                                    });
                                  },
                                  icon: const Icon(Icons.date_range),
                                ),
                              ),
                              const SizedBox(height: 10),
                              FieldInput(
                                title: "Total Stok",
                                hintText: "Masukkan total Stok",
                                controller: _totalStock,
                                textValidator: "",
                                keyboardType: TextInputType.number,
                                obsecureText: false,
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    value =
                                        formatNumber(value.replaceAll(".", ""));
                                    _totalStock.value = TextEditingValue(
                                      text: value,
                                      selection: TextSelection.collapsed(
                                          offset: value.length),
                                    );
                                  }
                                },
                              ),
                              const SizedBox(width: 10),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    "Sisa Stok : ${formatNumber((stock ?? 0).toString())}"),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton(
                                onPressed: Navigator.of(context).pop,
                                child: const Text("Kembali")),
                            FilledButton(
                              onPressed: _handlePreOrderSubmit,
                              child: ref
                                      .watch(openPreOrderNotifierProvider)
                                      .isLoading
                                  ? const LoadingInButton()
                                  : const Text("Simpan"),
                            )
                          ],
                        )
                      ],
                    ),
                  ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _handlePreOrderSubmit() {
    final stockTotal = ref.watch(remainingStockNotifier).data;
    if (_formKey.currentState!.validate()) {
      if (int.parse(_totalStock.text.replaceAll(".", "")) > stockTotal!) {
        PanaraConfirmDialog.show(
          context,
          message: "Jumlah stok melebihi sisa stok, apakah ingin lanjut?",
          confirmButtonText: "Lanjut",
          cancelButtonText: "Kembali",
          onTapConfirm: () {
            Navigator.of(context).pop();
            _submit();
          },
          onTapCancel: Navigator.of(context).pop,
          panaraDialogType: PanaraDialogType.warning,
        );
      } else {
        _submit();
      }
    }
  }

  _submit() {
    ref
        .watch(openPreOrderNotifierProvider.notifier)
        .updatePreOrder(
          startDateTime: selectedDateStart,
          endDateTime: selectedDateEnd,
          totalProduct: _totalStock.text.replaceAll(".", ""),
        )
        .then((value) {
      _getData();
      _totalStock.clear();
      ref.watch(isActiveNotifier.notifier).state = true;
    });
  }
}
