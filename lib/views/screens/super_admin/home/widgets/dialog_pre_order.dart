import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import '../../../../../features/pre-order/provider/pre_order_provider.dart';
import '../../../../../features/stock/provider/stock_provider.dart';
import '../../../../../utils/helper/formatted_currency.dart';
import '../../../../components/datetime_picker.dart';
import '../../../../components/form_datetime_widget.dart';
import '../../../../components/form_input.dart';
import '../../../../components/snackbar.dart';
import '../home_screen.dart';

class DialogPreOrder extends ConsumerStatefulWidget {
  const DialogPreOrder({super.key});

  @override
  ConsumerState createState() => _DialogPreOrderState();
}

class _DialogPreOrderState extends ConsumerState<DialogPreOrder> {
  final _globalKey = GlobalKey<FormState>();
  DateTime selectedDateStart = DateTime.now();
  DateTime selectedDateEnd = DateTime.now();
  late TextEditingController _totalStock;

  @override
  void initState() {
    _totalStock = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _totalStock.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stock = ref.watch(stockNotifier);
    return GestureDetector(
      onTap: Navigator.of(context).pop,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            margin: EdgeInsets.all(25.h),
            padding: EdgeInsets.all(25.h),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Form(
              key: _globalKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        "Pre-Order",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      trailing: IconButton(
                        onPressed: Navigator.of(context).pop,
                        icon: const Icon(Icons.close),
                      ),
                    ),
                    FormDatetimeWidget(
                        title: 'Tanggal & waktu Mulai',
                        selectedDatetime: selectedDateStart.toString(),
                        onTap: () async {
                          final datetime =
                              await DateTimePicker.showDateTimePicker(
                            context: context,
                            title: "Pilih tanggal dan waktu mulai",
                          );
                          setState(() {
                            selectedDateStart = datetime!;
                          });
                        }),
                    FormDatetimeWidget(
                        title: "Tanggal & waktu selesai",
                        selectedDatetime: selectedDateEnd.toString(),
                        onTap: () async {
                          final datetime =
                              await DateTimePicker.showDateTimePicker(
                            context: context,
                            title: "Pilih tanggal dan waktu selesai",
                          );
                          setState(() {
                            selectedDateEnd = datetime!;
                          });
                        }),
                    FieldInput(
                      title: "Total Stok",
                      hintText: "Masukkan total Stok",
                      controller: _totalStock,
                      textValidator: "",
                      keyboardType: TextInputType.number,
                      obsecureText: false,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          value = formatNumber(value.replaceAll(".", ""));
                          _totalStock.value = TextEditingValue(
                            text: value,
                            selection:
                                TextSelection.collapsed(offset: value.length),
                          );
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "Stock : ${stock.stockRemaining ?? 0}",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: Navigator.of(context).pop,
                          child: const Text("Kembali"),
                        ),
                        SizedBox(width: 10.w),
                        ElevatedButton(
                          onPressed: _handlePreOrderSubmit,
                          child: const Text("Simpan"),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handlePreOrderSubmit() {
    final stock = ref.watch(stockNotifier).stockRemaining ?? 0;
    if (_globalKey.currentState!.validate()) {
      Navigator.of(context).pop();
      int totalStock = int.parse(_totalStock.text.replaceAll(".", ""));
      if (totalStock > stock) {
        PanaraConfirmDialog.show(
          context,
          message: "Stok yang dimasukkan melebihi sisa stok, Lanjutkan?",
          confirmButtonText: "Lanjut",
          cancelButtonText: "Kembali",
          onTapConfirm: () {
            Navigator.of(context).pop();
            _sendConfirmationOpenPreOrder();
          },
          onTapCancel: Navigator.of(context).pop,
          panaraDialogType: PanaraDialogType.warning,
        );
      } else {
        _sendConfirmationOpenPreOrder();
      }
    }
  }

  ///handle request update open pre order
  void _sendConfirmationOpenPreOrder() {
    ref
        .watch(openPreOrderNotifierProvider.notifier)
        .updatePreOrder(
          startDateTime: selectedDateStart,
          endDateTime: selectedDateEnd,
          totalProduct: _totalStock.text.replaceAll(".", ""),
        )
        .then((success) {
      if (success) {
        ref.watch(isActiveProvider.notifier).state = true;
        showSnackbar(context, "Berhasil memperbaharui Pre-Order");
      } else {
        showSnackbar(
          context,
          ref.watch(openPreOrderNotifierProvider).error!,
          isWarning: true,
        );
      }
    });
  }
}
