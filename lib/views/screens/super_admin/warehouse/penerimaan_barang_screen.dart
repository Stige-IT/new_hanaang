import 'package:admin_hanaang/config/router/router_config.dart';
import 'package:admin_hanaang/features/penerimaan_barang/provider/penerimaan_barang_provider.dart';
import 'package:admin_hanaang/models/penerimaan_barang/penerimaan_barang.dart';
import 'package:admin_hanaang/utils/extensions/currency_format.dart';
import 'package:admin_hanaang/views/components/navigation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PenerimaanBarangScreen extends ConsumerStatefulWidget {
  const PenerimaanBarangScreen({super.key});

  @override
  ConsumerState createState() => _PenerimaanBarangScreenState();
}

class _PenerimaanBarangScreenState
    extends ConsumerState<PenerimaanBarangScreen> {
  @override
  void initState() {
    Future.microtask(() => ref
        .watch(penerimaanBarangNotifier.notifier)
        .getData(makeLoading: true));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<PenerimaanBarang>? data = ref.watch(penerimaanBarangNotifier).data;
    final isLoading = ref.watch(penerimaanBarangNotifier).isLoading;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text("Penerimaan Barang"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1), () {});
        },
        child: isLoading != null && isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 75.0),
                itemBuilder: (_, i) {
                  PenerimaanBarang? barang = data?[i];
                  return Card(
                    child: ListTile(
                      title: const Text("No.Penerimaan Barang",
                          style: TextStyle(
                            fontSize: 14,
                          )),
                      subtitle: Text(
                        barang?.noPenerimaanBarang ?? "",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Text(
                          int.parse(barang?.totalPrice ?? "0").convertToIdr(),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      onTap: () => nextPage(
                          context, "${AppRoutes.sa}/penerimaan-barang/detail",
                          argument: barang?.id),
                    ),
                  );
                },
                separatorBuilder: (_, i) => const SizedBox(height: 7),
                itemCount: data?.length ?? 0,
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            nextPage(context, "${AppRoutes.sa}/penerimaan-barang/form"),
        child: const Icon(Icons.add),
      ),
    );
  }
}
