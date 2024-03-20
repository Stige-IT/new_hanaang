import 'package:admin_hanaang/models/shopping.dart';
import 'package:admin_hanaang/utils/extensions/currency_format.dart';
import 'package:admin_hanaang/utils/extensions/date_formater.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../features/shopping/provider/shopping_provider.dart';
import '../../../../../components/loading_in_button.dart';

class DetailShopping extends ConsumerWidget {
  const DetailShopping({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(shoppingDetailNotifier);
    final detailShopping = state.data;
    return Expanded(
      child: Builder(
        builder: (_) {
          if (ref.watch(indexSelectedProvider) == null) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.emoji_emotions_sharp),
                  SizedBox(height: 5),
                  Text("Pilih terlebih dahulu data belanja di samping"),
                ],
              ),
            );
          } else if (state.isLoading) {
            return Center(
              child:
                  LoadingInButton(color: Theme.of(context).colorScheme.primary),
            );
          } else if (state.error != null) {
            final shoppingId = ref.watch(indexSelectedProvider);
            return Center(
              child: OutlinedButton.icon(
                onPressed: () => ref
                    .read(shoppingDetailNotifier.notifier)
                    .getDetail(shoppingId!),
                icon: const Icon(Icons.refresh),
                label: Text(state.error!),
              ),
            );
          }
          List<ShoppingItem> items = detailShopping?.shoppingItem ?? [];
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  title: const Text("Detail Belanja",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      )),
                  subtitle: Text(
                      "Dibuat pada : ${detailShopping!.createdAt!.timeFormat()}"),
                  trailing: Text(
                    "Dibuat oleh\n${detailShopping.createdBy!.name}",
                    textAlign: TextAlign.center,
                  ),
                ),
                ListTile(
                  title: const Text("Total pengeluaran"),
                  subtitle:
                      Text(int.parse(detailShopping.totalPrice!).convertToIdr(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          )),
                  trailing: Text("Jumlah barang\n${items.length}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      )),
                ),

                //data table history shopping material
                Expanded(
                  child: Card(
                    elevation: 2,
                    child: SingleChildScrollView(
                      child: DataTable(
                        columnSpacing: 0,
                        showBottomBorder: true,
                        columns: const [
                          DataColumn(label: Text("No")),
                          DataColumn(
                              label: Text("Nama\npengeluaran",
                                  textAlign: TextAlign.center)),
                          DataColumn(label: Text("Jumlah")),
                          DataColumn(
                              label: Text("Total\nHarga",
                                  textAlign: TextAlign.center)),
                          DataColumn(label: Text("Tanggal")),
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
                                  int.parse(items[i].totalPrice ?? "0")
                                      .convertToIdr(),
                                )),
                                DataCell(
                                    Text(items[i].createdAt!.timeFormat())),
                              ],
                            )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
