import 'package:admin_hanaang/features/penerimaan_barang/provider/penerimaan_barang_provider.dart';
import 'package:admin_hanaang/utils/extensions/currency_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/penerimaan_barang/detail_penerimaan_barang.dart';

class DetailPenerimaanBarangScreen extends ConsumerStatefulWidget {
  final String dataId;

  const DetailPenerimaanBarangScreen(this.dataId, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DetailPenerimaanBarangScreenState();
}

class _DetailPenerimaanBarangScreenState
    extends ConsumerState<DetailPenerimaanBarangScreen> {
  @override
  void initState() {
    Future.microtask(() => ref
        .watch(detailPenerimaanBarangNotifier.notifier)
        .getDetailData(widget.dataId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(detailPenerimaanBarangNotifier);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text("Detail"),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
              ? Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.warning, size: 30),
                    Text(state.error!),
                  ],
                ))
              : ListView(
                  children: [
                    ListTile(
                      title: const Text("No.Penerimaan Barang"),
                      subtitle: Text(state.data?.noPenerimaanBarang ?? "-"),
                    ),
                    ListTile(
                      title: const Text("Total Harga"),
                      subtitle: Text(int.parse(state.data?.totalPrice ?? "0")
                          .convertToIdr()),
                    ),
                    ListTile(
                      title: const Text("Dibuat Oleh:"),
                      subtitle: Text(state.data?.createdBy ?? "-"),
                    ),
                    const ListTile(
                      title: Text("Bahan Baku",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    const Divider(thickness: 2),
                    for (Item item in state.data?.item ?? [])
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                          10,
                        )),
                        child: ListTile(
                          dense: true,
                          title: const Text("Bahan Baku"),
                          subtitle: Text("${item.rawMaterial?.name}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              )),
                          trailing: Text(
                              "${item.quantity ?? 0} ${item.rawMaterial?.unit}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              )),
                        ),
                      )
                  ],
                ),
    );
  }
}
