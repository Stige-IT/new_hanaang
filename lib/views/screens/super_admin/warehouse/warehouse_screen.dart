import 'package:admin_hanaang/config/router/router_config.dart';
import 'package:admin_hanaang/views/components/appbar.dart';
import 'package:admin_hanaang/views/components/navigation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../features/order/order.dart';
import '../../../../features/retur/provider/retur_provider.dart';
import '../../../../features/stock/provider/stock_provider.dart';
import '../../../components/card_total_users.dart';
import '../../../components/tile.dart';

class WarehouseScreen extends ConsumerStatefulWidget {
  const WarehouseScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _WarehouseScreenState();
}

class _WarehouseScreenState extends ConsumerState<WarehouseScreen> {
  _getData() async {
    ref.watch(totalOrderNotifier.notifier).getTotalOrders();
    ref.watch(stockNotifier.notifier).getStock();
    ref.watch(returProcessNotifier.notifier).getRetur();
    ref.watch(returAcceptNotifier.notifier).getRetur();
    ref.watch(returRejectNotifier.notifier).getRetur();
    ref.watch(returFinishNotifier.notifier).getRetur();
  }

  @override
  void initState() {
    Future.microtask(() {
      ref.watch(stockNotifier.notifier).getStock();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final stock = ref.watch(stockNotifier);
    final totalFinishRetur = ref.watch(returFinishNotifier).data?.length;
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1), () {
          _getData();
        });
      },
      child: Scaffold(
        body: CustomScrollView(slivers: [
          const AppBarSliver(),
          SliverList(
              delegate: SliverChildListDelegate.fixed([
            GridView.count(
              padding: const EdgeInsets.all(10),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              childAspectRatio: 2 / 1,
              crossAxisCount: 2,
              children: [
                CardUsers(
                    title: "Total Produk",
                    total: stock.stockTotal ?? 0,
                    onTap: () {}),
                CardUsers(
                    title: "Produk Terjual",
                    total: stock.stockSold ?? 0,
                    onTap: () {}),
                CardUsers(
                    title: "Produk Retur",
                    total: totalFinishRetur ?? 0,
                    onTap: () {}),
                CardUsers(
                    title: "Sisa Produk",
                    total: stock.stockRemaining ?? 0,
                    onTap: () {}),
              ],
            ),
            Column(
              children: [
                Tile(
                  title: "Suplayer",
                  onTap: () => nextPage(context, "${AppRoutes.sa}/suplayer"),
                ),
                Tile(
                  title: "Bahan Baku",
                  onTap: () =>
                      nextPage(context, "${AppRoutes.sa}/menu-material"),
                ),
                Tile(
                  title: "Resep",
                  onTap: () => nextPage(context, "${AppRoutes.sa}/recipt"),
                ),
                Tile(
                  title: "Setting hak akses admin",
                  onTap: () => nextPage(context, "${AppRoutes.sa}/access-admin"),
                ),
              ],
            )
          ]))
        ]),
      ),
    );
  }
}
