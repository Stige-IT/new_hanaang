import 'package:admin_hanaang/features/taking_order/provider/payment_provider.dart';
import 'package:admin_hanaang/models/order_detail.dart';
import 'package:admin_hanaang/models/taking_order.dart';
import 'package:admin_hanaang/views/components/dialog_loading.dart';
import 'package:admin_hanaang/views/components/form_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../features/order/order.dart';
import '../../../components/snackbar.dart';
import '../../../components/tile_taking_order_detail.dart';

class DetailTakingOrderScreen extends ConsumerStatefulWidget {
  final OrderDetailData orderData;

  const DetailTakingOrderScreen(this.orderData, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DetailTakingOrderScreenState();
}

class _DetailTakingOrderScreenState
    extends ConsumerState<DetailTakingOrderScreen> {
  late TextEditingController _quantityCtrl;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _getData() async {
    final id = widget.orderData.orderTaking!.id;
    ref
        .watch(takingOrderNotifier.notifier)
        .getTakingOrder(id!, makeLoading: true);
    ref.watch(orderByIdNotifier.notifier).getOrdersById(widget.orderData.id!);
  }

  @override
  void initState() {
    Future.microtask(() => _getData());
    _quantityCtrl = TextEditingController(text: "0");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(takingOrderNotifier);
    final takingOrderData = state.data;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text("Detail Pengambilan"),
      ),
      body: Stack(
        children: [
          RefreshIndicator(onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1), () {
              _getData();
            });
          }, child: Builder(builder: (_) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.error != null) {
              return Center(child: Text(state.error!));
            } else if (takingOrderData == null || takingOrderData.isEmpty) {
              return const Center(child: Text("Tidak ada Data"));
            }
            return _listTakingOrder(takingOrderData);
          })),
          if (ref.watch(createTakingOrderNotifier).isLoading)
            const DialogLoading()
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          elevation: 2,
          onPressed: () {
            _quantityCtrl.text = '0';
            final size = MediaQuery.of(context).size;
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (_) => StatefulBuilder(builder: (_, state) {
                      return Form(
                        key: _formKey,
                        child: AlertDialog(
                          scrollable: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          insetPadding: const EdgeInsets.all(20),
                          actionsPadding: const EdgeInsets.all(20),
                          title: SizedBox(
                              width: size.width,
                              child: const Text("Pengambilan Baru")),
                          content: _quantityTotal(state),
                          actions: [
                            OutlinedButton(
                                onPressed: Navigator.of(context).pop,
                                child: const Text("Kembali")),
                            FilledButton(
                                onPressed: _handleSubmit,
                                child: const Text("Simpan"))
                          ],
                        ),
                      );
                    }));
          },
          label: const Text(
            "+ Pengambilan Baru",
            style: TextStyle(fontSize: 14),
          )),
    );
  }

  _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop();
      final id = widget.orderData.orderTaking!.id;
      ref
          .watch(createTakingOrderNotifier.notifier)
          .createTakingOrder(
            id!,
            quantity: _quantityCtrl.text,
            orderId: widget.orderData.id!,
          )
          .then((success) {
        if (!success) {
          showSnackbar(context, ref.watch(createTakingOrderNotifier).error!,
              isWarning: true);
        }
      });
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
                    child: FieldInput(
                      suffixText: "/$quantityTotal cup",
                      hintText: "",
                      controller: _quantityCtrl,
                      textValidator: "",
                      keyboardType: TextInputType.number,
                      obsecureText: false,
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
                        } else if (int.parse(value) >
                            int.parse(quantityTotal!)) {
                          return "Pengambilan tidak boleh lebih dari total sisa";
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

  ListView _listTakingOrder(List<TakingOrder> takingOrderData) {
    return ListView.separated(
      itemCount: takingOrderData.length,
      itemBuilder: (_, i) {
        TakingOrder takingOrder = takingOrderData[i];
        return TilePaymentDetailTakeOrder(takingOrder: takingOrder);
      },
      separatorBuilder: (_, i) {
        return const SizedBox(height: 7);
      },
    );
  }
}
