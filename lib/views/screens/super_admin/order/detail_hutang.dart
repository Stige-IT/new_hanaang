import 'package:admin_hanaang/config/router/router_config.dart';
import 'package:admin_hanaang/features/hutang/provider/hutang_provider.dart';
import 'package:admin_hanaang/utils/extensions/currency_format.dart';
import 'package:admin_hanaang/utils/extensions/date_formater.dart';
import 'package:admin_hanaang/utils/helper/check_label_with_id.dart';
import 'package:admin_hanaang/views/components/label.dart';
import 'package:admin_hanaang/views/components/navigation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/detail_hutang.dart';

class DetailHutangScreen extends ConsumerStatefulWidget {
  final String hutangId;

  const DetailHutangScreen(this.hutangId, {super.key});

  @override
  ConsumerState createState() => _DetailHutangScreenState();
}

class _DetailHutangScreenState extends ConsumerState<DetailHutangScreen> {
  @override
  void initState() {
    Future.microtask(() => ref
        .watch(detailHutangNotifier.notifier)
        .getDetailHutang(widget.hutangId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(detailHutangNotifier);
    final detailHutang = state.data;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: const Text("Detail Hutang"),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1), () {
              ref
                  .watch(detailHutangNotifier.notifier)
                  .getDetailHutang(widget.hutangId);
            });
          },
          child: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : state.error != null || state.data == null
                  ? Center(child: Text(state.error ?? ""))
                  : ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(15.0),
                      children: [
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                const Text("Total Hutang"),
                                const SizedBox(height: 5),
                                Text(
                                  _totalHutang(detailHutang ?? [])
                                      .convertToIdr(),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        ///[*list data hutang]
                        Column(
                          children: detailHutang!
                              .map((data) => Card(
                                    margin: const EdgeInsets.only(bottom: 20),
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0)),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(15.0),
                                      onTap: () => nextPage(context,
                                          "${AppRoutes.sa}/order-list/detail",
                                          argument: data.id),
                                      child: Column(
                                        children: [
                                          ListTile(
                                            visualDensity: const VisualDensity(
                                                vertical: -3),
                                            dense: true,
                                            title: Text(data.createdAt!
                                                .dateFormatWithDay()),
                                            trailing: Text(
                                              data.orderNumber!,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          const Divider(thickness: 3),
                                          ListTile(
                                            visualDensity: const VisualDensity(
                                                vertical: -3),
                                            dense: true,
                                            title: const Text(
                                              "Status Pengambilan",
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            trailing: SizedBox(
                                                width: 100,
                                                height: 25,
                                                child: Label(
                                                  title: data.orderTakingStatus,
                                                  status: checkStatus(
                                                      data.orderTakingStatus!),
                                                )),
                                          ),
                                          ListTile(
                                            visualDensity: const VisualDensity(
                                                vertical: -3),
                                            dense: true,
                                            title: const Text(
                                                "Status Pembayaran",
                                                style: TextStyle(fontSize: 16)),
                                            trailing: SizedBox(
                                              width: 100,
                                              height: 25,
                                              child: Label(
                                                title: data.paymentStatus,
                                                status: checkStatus(
                                                    data.paymentStatus!),
                                              ),
                                            ),
                                          ),
                                          ListTile(
                                            visualDensity: const VisualDensity(
                                                vertical: -3),
                                            dense: true,
                                            title: const Text(
                                                "Jumlah Pembayaran",
                                                style: TextStyle(fontSize: 16)),
                                            trailing: Text(
                                                int.parse(data.totalPayment!)
                                                    .convertToIdr(),
                                                style: const TextStyle(
                                                    fontSize: 16)),
                                          ),
                                          ListTile(
                                            visualDensity: const VisualDensity(
                                                vertical: -3),
                                            dense: true,
                                            title: const Text("Sudah dibayar",
                                                style: TextStyle(fontSize: 16)),
                                            trailing: Text(
                                                int.parse(data.alreadyPaid!)
                                                    .convertToIdr(),
                                                style: const TextStyle(
                                                    fontSize: 16)),
                                          ),
                                          ListTile(
                                            visualDensity: const VisualDensity(
                                                vertical: -3),
                                            dense: true,
                                            title: const Text("Hutang",
                                                style: TextStyle(fontSize: 16)),
                                            trailing: Text(
                                                int.parse(data.hutang!)
                                                    .convertToIdr(),
                                                style: const TextStyle(
                                                    fontSize: 16)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ))
                              .toList(),
                        )
                      ],
                    ),
        ));
  }

  int _totalHutang(List<DetailHutang> data) {
    int total = 0;
    for (DetailHutang hutang in data) {
      total += int.parse(hutang.hutang!);
    }
    return total;
  }
}
