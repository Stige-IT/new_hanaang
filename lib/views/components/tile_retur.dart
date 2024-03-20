import 'package:admin_hanaang/features/retur/provider/retur_provider.dart';
import 'package:admin_hanaang/utils/extensions/date_formater.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/router/router_config.dart';
import '../../models/retur.dart';
import 'navigation_widget.dart';

class TileRetur extends ConsumerWidget {
  final List<Retur> returs;
  final ScrollController scrollController;
  final String title;

  const TileRetur(
      {super.key,
      required this.returs,
      required this.scrollController,
      required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1), () {
          switch (title) {
            case "Diproses":
              ref.watch(returProcessNotifier.notifier).refresh();
              break;
            case "Disetujui":
              ref.watch(returAcceptNotifier.notifier).refresh();
              break;
            case "Ditolak":
              ref.watch(returRejectNotifier.notifier).refresh();
              break;
            case "Selesai":
              ref.watch(returFinishNotifier.notifier).refresh();
              break;
            default:
          }
        });
      },
      child: (returs.isEmpty)
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.local_drink, color: Theme.of(context).colorScheme.primary, size: 75),
                  const SizedBox(height: 10),
                  const Text("Tidak ada data"),
                ],
              ),
            )
          : ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: scrollController,
              padding: const EdgeInsets.all(15.0),
              itemBuilder: (_, i) {
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 2,
                  color: Theme.of(context).colorScheme.surface,
                  child: ListTile(
                    onTap: () => nextPage(
                        context, "${AppRoutes.sa}/retur/detail",
                        argument: returs[i]),
                    leading: const Icon(Icons.assignment_return_outlined),
                    title: Text(
                      returs[i].returNumber!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "${returs[i].date!.timeFormat()} WIB",
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: Text(
                      "${returs[i].quantity} Cup",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                );
              },
              separatorBuilder: (_, i) => const SizedBox(height: 5),
              itemCount: returs.length,
            ),
    );
  }
}
