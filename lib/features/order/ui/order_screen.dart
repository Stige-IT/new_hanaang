part of '../order.dart';

class OrderScreen extends ConsumerStatefulWidget {
  const OrderScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OrderScreenState();
}

class _OrderScreenState extends ConsumerState<OrderScreen> {

  void _getData() async {
    ref.read(totalPreOrderNotifier.notifier).getTotal();
    ref.read(totalOrderNotifier.notifier).getTotalOrders();
    ref.read(totalReturNotifier.notifier).getTotal();
  }

  @override
  void initState() {
    Future.microtask(() => _getData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1), () => _getData());
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            const AppBarSliver(),
            SliverList(
              delegate: SliverChildListDelegate.fixed([
                GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(10),
                  shrinkWrap: true,
                  childAspectRatio: 2 / 1.5,
                  crossAxisCount: 3,
                  children: [
                    CardUsers(
                      title: "Setting Bonus",
                      onTap: () =>
                          nextPage(context, "${AppRoutes.sa}/setting-bonus"),
                    ),
                    CardUsers(
                      title: "Setting Cashback",
                      onTap: () =>
                          nextPage(context, "${AppRoutes.sa}/setting-cashback"),
                    ),
                    CardUsers(
                      title: "Setting harga Produk",
                      onTap: () =>
                          nextPage(context, "${AppRoutes.sa}/setting-harga"),
                    ),
                    CardUsers(
                      title: "Pre Order",
                      total: ref.watch(totalPreOrderNotifier).data ?? 0,
                      onTap: () =>
                          nextPage(context, "${AppRoutes.sa}/pre-order-list"),
                    ),
                    CardUsers(
                      title: "Pesanan",
                      total: ref.watch(totalOrderNotifier).data ?? 0,
                      onTap: () =>
                          nextPage(context, "${AppRoutes.sa}/order-list"),
                    ),
                    CardUsers(
                      title: "Retur",
                      total: ref.watch(totalReturNotifier).data ?? 0,
                      onTap: () => nextPage(context, "${AppRoutes.sa}/retur"),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Tile(
                      title: "Daftar Pre Order",
                      onTap: () =>
                          nextPage(context, "${AppRoutes.sa}/pre-order-list"),
                    ),
                    Tile(
                      title: "Daftar Pesanan",
                      onTap: () =>
                          nextPage(context, "${AppRoutes.sa}/order-list"),
                    ),
                    Tile(
                      title: "Daftar Pesanan Retur",
                      onTap: () => nextPage(context, '${AppRoutes.sa}/retur'),
                    ),
                    Tile(
                      title: "Daftar Hutang",
                      onTap: () => nextPage(context, "${AppRoutes.sa}/hutang"),
                    ),
                  ],
                )
              ]),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          heroTag: "new-order",
          onPressed: () => nextPage(context, "${AppRoutes.sa}/order/form"),
          label: const Text("Pesanan Baru"),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }
}
