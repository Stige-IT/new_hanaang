import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../features/stock/provider/stock_provider.dart';
import 'card_product.dart';

class GridviewProductStock extends ConsumerWidget {
  const GridviewProductStock({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
        height: size.height * 0.6,
        width: size.width * 0.6,
        child: Center(
          child: GridView.count(
            physics:
            const NeverScrollableScrollPhysics(),
            childAspectRatio: 2.0,
            shrinkWrap: true,
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: [
              CardProduct(
                title: "Total stok produk",
                value:
                "${ref.watch(totalStockNotifier).data ?? 0}",
                icon: Icons.numbers,
              ),
              CardProduct(
                title: "Stock produk terjual",
                value:
                "${ref.watch(soldStockNotifier).data ?? 0}",
                icon: Icons.output_outlined,
              ),
              CardProduct(
                title: "Sisa stok produk",
                value:
                "${ref.watch(remainingStockNotifier).data ?? 0}",
                icon: Icons.inbox,
              ),
              CardProduct(
                title: "Total retur produk",
                value:
                "${ref.watch(returStockNotifier).data ?? 0}",
                icon: Icons.keyboard_return,
              ),
            ],
          ),
        ));
  }
}
