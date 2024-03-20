import 'package:admin_hanaang/features/order/order.dart';
import 'package:admin_hanaang/models/detail_transaction.dart';
import 'package:admin_hanaang/utils/extensions/capital_first.dart';
import 'package:admin_hanaang/utils/extensions/date_formater.dart';
import 'package:admin_hanaang/utils/helper/formatted_currency.dart';
import 'package:admin_hanaang/utils/helper/show_dialog_image_preview.dart';
import 'package:admin_hanaang/views/screens/super_admin/order/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../components/empty_widget.dart';
import '../../../../components/error_button_widget.dart';
import '../../../../components/loading_in_button.dart';

class DetailOrderTransactionScreen extends ConsumerStatefulWidget {
  final String orderId;
  const DetailOrderTransactionScreen(this.orderId, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DetailOrderTransactionScreenState();
}

class _DetailOrderTransactionScreenState
    extends ConsumerState<DetailOrderTransactionScreen> {
  void _getData() {
    ref.watch(orderTransactionNotifier.notifier).get(widget.orderId);
  }

  @override
  void initState() {
    Future.microtask(() => _getData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(orderTransactionNotifier);
    final isPrint = ref.watch(isPrintValueProvider);
    final tempTransactionPrint = ref.watch(tempTransactionProvider);
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: true,
        title: const Text("Detail Transaksi Pesanan"),
        actions: [
          IconButton(
            icon: Icon(isPrint ? Icons.print : Icons.print_outlined),
            onPressed: () {
              ref.read(isPrintValueProvider.notifier).state = !isPrint;
            },
          )
        ],
      ),
      body: Builder(
        builder: (_) {
          if (state.isLoading) {
            return const Center(child: CircularLoading());
          } else if (state.error != null) {
            return Center(
              child: ErrorButtonWidget(errorMsg: '', onTap: () => _getData()),
            );
          } else if (state.data == null) {
            return const Center(child: EmptyWidget());
          } else {
            final data = state.data!;
            return RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(
                    const Duration(seconds: 1), () => _getData());
              },
              child: Column(
                children: [
                  if (isPrint)
                    ListTile(
                      leading: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          ref.read(tempTransactionProvider.notifier).clear();
                          ref.invalidate(isPrintValueProvider);
                        },
                      ),
                      title: Text("${tempTransactionPrint.length} dipilih"),
                      trailing: TextButton(
                        onPressed: () {
                          print("===============sample print=============");
                        },
                        child: const Text("Print"),
                      ),
                    ),
                  Expanded(
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(15.0),
                      itemBuilder: (_, i) {
                        final isAlready = ref
                            .watch(tempTransactionProvider.notifier)
                            .isAlready(data[i]);
                        return InkWell(
                          onTap: () {
                            if (isPrint) {
                              ref
                                  .read(tempTransactionProvider.notifier)
                                  .add(data[i]);
                            }
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              side: isAlready
                                  ? const BorderSide(
                                      width: 2, color: Colors.green)
                                  : BorderSide.none,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                children: [
                                  if (data[i].numberOfPayment != "0")
                                    TileOrderWIdget(
                                      title:
                                          "Pembayaran ${data[i].paymentMethodId?.name?.capitalize()}",
                                      child: Text(
                                          "Rp ${formatNumber(data[i].numberOfPayment)}"),
                                    ),
                                  if (data[i].numberOfTaking != null)
                                    TileOrderWIdget(
                                      title: "Pengambilan",
                                      child: Text(
                                          "${formatNumber(data[i].numberOfTaking)} Cup"),
                                    ),
                                  if (data[i].proofOfPayment != null)
                                    TileOrderWIdget(
                                      title: "Bukti Pembayaran",
                                      child: TextButton(
                                        onPressed: () {
                                          context.showDialogImagePreview(
                                              data[i].proofOfPayment!);
                                        },
                                        child: const Text("Lihat gambar"),
                                      ),
                                    ),
                                  TileOrderWIdget(
                                    title: "Dibuat oleh",
                                    child: TextButton.icon(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (_) =>
                                                DialogCreatedByWidget(
                                                    data[i].createdBy!),
                                          );
                                        },
                                        icon: const Icon(Icons.person),
                                        label: Text(
                                            data[i].createdBy?.name ?? "-")),
                                  ),
                                  const SizedBox(height: 10),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      data[i]
                                              .paymentMethodId
                                              ?.createdAt
                                              ?.timeFormat() ??
                                          '-',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: data.length,
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class DialogCreatedByWidget extends StatelessWidget {
  final CreatedBy createdBy;
  const DialogCreatedByWidget(this.createdBy, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Detail Pembuat'),
                trailing: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text("Nama"),
                trailing: Text(createdBy.name ?? ""),
              ),
              ListTile(
                leading: const Icon(Icons.email),
                title: const Text("Email"),
                trailing: Text(createdBy.email ?? ""),
              ),
              ListTile(
                leading: const Icon(Icons.phone),
                title: const Text("Nomor Telepon"),
                trailing: Text(createdBy.phoneNumber ?? ""),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
