import 'dart:developer';

import 'package:admin_hanaang/config/router/router_config.dart';
import 'package:admin_hanaang/config/theme.dart';
import 'package:admin_hanaang/features/bank-account/provider/bank-account_provider.dart';
import 'package:admin_hanaang/models/history_income.dart';
import 'package:admin_hanaang/models/history_outcome.dart';
import 'package:admin_hanaang/utils/extensions/currency_format.dart';
import 'package:admin_hanaang/utils/extensions/date_formater.dart';
import 'package:admin_hanaang/utils/helper/checkStatusLabel.dart';
import 'package:admin_hanaang/views/components/label.dart';
import 'package:admin_hanaang/views/components/loading_in_button.dart';
import 'package:admin_hanaang/views/components/navigation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailBankHistoryScreen extends ConsumerStatefulWidget {
  final String bankHistoryId;
  final bool isIncome;

  const DetailBankHistoryScreen(this.bankHistoryId, this.isIncome, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DetailBankHistoryScreenState();
}

class _DetailBankHistoryScreenState
    extends ConsumerState<DetailBankHistoryScreen> {
  @override
  void initState() {
    Future.microtask(() => ref
        .read(detailBankHistoryNotifier.notifier)
        .getDetailHistory(widget.bankHistoryId, isIncome: widget.isIncome));
    super.initState();
  }

  @override
  void dispose() {
    ref.invalidate(detailBankHistoryNotifier);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(detailBankHistoryNotifier);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Detail Riwayat ${widget.isIncome ? "Pemasukan" : "Pengeluaran"}",
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1), () {
            ref.read(detailBankHistoryNotifier.notifier).getDetailHistory(
                widget.bankHistoryId,
                isIncome: widget.isIncome);
          });
        },
        child: Builder(builder: (_) {
          if (state.isLoading) {
            return Center(child: LoadingInButton(color: Theme.of(context).colorScheme.primary));
          } else if (state.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.warning_amber, size: 50),
                  Text(state.error!),
                ],
              ),
            );
          } else if (state.data == null) {
            return const Center(
              child: Column(
                children: [
                  Icon(Icons.account_balance_wallet_outlined, size: 50),
                  Text("Data tidak ditemukan"),
                ],
              ),
            );
          } else {
            log(widget.isIncome.toString());
            if (widget.isIncome) {
              final stateHistory =
                  ref.watch(detailBankHistoryNotifier).data as HistoryIncome;
              return ListView(
                padding: const EdgeInsets.all(10.0),
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.attach_money,
                      color: widget.isIncome ? Colors.green : Colors.red,
                    ),
                    visualDensity: const VisualDensity(vertical: -3),
                    title: const Text("Tipe Pemasukan",
                        style: TextStyle(fontSize: 12)),
                    subtitle: Text(
                      stateHistory.type?.name ?? "",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.date_range_rounded),
                    visualDensity: const VisualDensity(vertical: -3),
                    title: const Text("Pemasukan dibuat",
                        style: TextStyle(fontSize: 12)),
                    subtitle: Text(
                      (stateHistory.category?.createdAt?.dateFormatWithDay()) ??
                          "",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Detail Pesanan",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        children: [
                          ListTile(
                            visualDensity: const VisualDensity(vertical: -3),
                            title: const Text("No.Pesanan",
                                style: TextStyle(fontSize: 12)),
                            subtitle: Text(
                              (stateHistory.order?.orderNumber) ?? "",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            trailing: OutlinedButton(
                              onPressed: (){
                                nextPage(context, "${AppRoutes.sa}/order-list/detail", argument: stateHistory.order?.id);
                              },
                              child: const Text("Lihat Pesanan", style: TextStyle(fontSize: 12),),
                            ),
                          ),

                          ListTile(
                            visualDensity: const VisualDensity(vertical: -3),
                            title: const Text("Total Harga",
                                style: TextStyle(fontSize: 12)),
                            subtitle: Text(
                              int.parse(stateHistory.order?.totalPrice ?? "0").convertToIdr(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          if(stateHistory.order?.paymentStatus != null)
                          ListTile(
                              visualDensity: const VisualDensity(vertical: -3),
                              title: const Text("Status Pembayaran",
                                  style: TextStyle(fontSize: 16)),
                              trailing: SizedBox(
                                width: 100,
                                height: 25,
                                child: Label(
                                  status: checkStatus(stateHistory.order?.paymentStatus ?? "-"),
                                  title: checkNamed(stateHistory.order?.paymentStatus ?? "-"),
                                ),
                              )
                          ),
                          if(stateHistory.order?.orderTakingStatus != null)
                          ListTile(
                              visualDensity: const VisualDensity(vertical: -3),
                              title: const Text("Status Pengambilan",
                                  style: TextStyle(fontSize: 16)),
                              trailing: SizedBox(
                                width: 100,
                                height: 25,
                                child: Label(
                                  status: checkStatus(stateHistory.order?.orderTakingStatus ?? "-"),
                                  title: checkNamed(stateHistory.order?.orderTakingStatus ?? "-"),
                                ),
                              )
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              final stateHistory =
                  ref.watch(detailBankHistoryNotifier).data as HistoryOutcome;
              return ListView(
                padding: const EdgeInsets.all(10.0),
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.attach_money,
                      color: widget.isIncome ? Colors.green : Colors.red,
                    ),
                    visualDensity: const VisualDensity(vertical: -3),
                    title: const Text("Tipe Pemasukan",
                        style: TextStyle(fontSize: 12)),
                    subtitle: Text(
                      stateHistory.type?.name ?? "",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.date_range_rounded),
                    visualDensity: const VisualDensity(vertical: -3),
                    title: const Text("Pemasukan dibuat",
                        style: TextStyle(fontSize: 12)),
                    subtitle: Text(
                      (stateHistory.category?.createdAt?.dateFormatWithDay()) ??
                          "",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Detail Penerimaan Barang",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        children: [
                          ListTile(
                            visualDensity: const VisualDensity(vertical: -3),
                            title: const Text("No.Penerimaan Barang",
                                style: TextStyle(fontSize: 12)),
                            subtitle: Text(
                              (stateHistory.penerimaanBarang?.noPenerimaanBarang) ?? "",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            trailing: OutlinedButton(
                              onPressed: (){
                                nextPage(context, "${AppRoutes.sa}/penerimaan-barang/detail", argument: stateHistory.penerimaanBarang?.id);
                              },
                              child: const Text("Lihat detail", style: TextStyle(fontSize: 12),),
                            ),
                          ),

                          ListTile(
                            visualDensity: const VisualDensity(vertical: -3),
                            title: const Text("Total Harga",
                                style: TextStyle(fontSize: 12)),
                            subtitle: Text(
                              int.parse(stateHistory.penerimaanBarang?.totalPrice ?? "0").convertToIdr(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          ListTile(
                            visualDensity: const VisualDensity(vertical: -3),
                            title: const Text("Total Bahan Baku diterima",
                                style: TextStyle(fontSize: 12)),
                            subtitle: Text(
                              "${(stateHistory.penerimaanBarang?.item ?? []).length}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          }
        }),
      ),
    );
  }
}
