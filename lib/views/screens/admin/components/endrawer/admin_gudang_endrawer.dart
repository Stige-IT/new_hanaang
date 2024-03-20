import 'package:admin_hanaang/features/manage_access_warehouse/provider/manage_accces_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../config/router/router_config.dart';
import '../../../../components/navigation_widget.dart';
import '../gridview_product_stock.dart';

class AdminGudangEndrawer extends ConsumerWidget {
  const AdminGudangEndrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final access = ref.watch(manageAccessNotifier).data;
    return Column(
      children: [
        if (access?[1].read == "1")
          Card(
            color: Theme.of(context).colorScheme.surface,
            child: ListTile(
              onTap: () => nextPage(context, "${AppRoutes.admin}/suplayer"),
              leading: const Icon(Icons.settings_applications),
              title: const Text('Suplayer'),
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
            ),
          ),
        if (access?[0].read == "1" ||
            access?[2].read == "1" ||
            access?[3].read == "1")
          Card(
            color: Theme.of(context).colorScheme.surface,
            child: ExpansionTile(
              leading: const Icon(Icons.shopping_bag),
              title: const Text("Bahan Baku"),
              children: [
                if (access?[0].read == "1")
                  ListTile(
                    onTap: () =>
                        nextPage(context, "${AppRoutes.admin}/material"),
                    title: const Text('Bahan Baku'),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded),
                  ),
                if (access?[2].read == "1")
                  ListTile(
                    onTap: () =>
                        nextPage(context, "${AppRoutes.admin}/units"),
                    title: const Text('Unit'),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded),
                  ),
                if (access?[3].read == "1")
                  ListTile(
                    onTap: () =>
                        nextPage(context, "${AppRoutes.admin}/penerimaan-barang"),
                    title: const Text('Penerimaan barang'),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded),
                  ),
              ],
            ),
          ),
        if (access?[4].read == "1")
          Card(
            color: Theme.of(context).colorScheme.surface,
            child: ListTile(
              onTap: () => nextPage(context, "${AppRoutes.admin}/recipt"),
              leading: const Icon(Icons.shopping_cart_outlined),
              title: const Text('Resep'),
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
            ),
          ),
        Card(
          color: Theme.of(context).colorScheme.surface,
          child: ListTile(
            onTap: () {
              Navigator.of(context).pop();
              showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      title: const Text("Info Produk"),
                      content: const GridviewProductStock(),
                      actions: [
                        OutlinedButton(
                            onPressed: Navigator.of(context).pop,
                            child: const Text(
                              "Kembali",
                            )),
                      ],
                    );
                  });
            },
            leading: const Icon(Icons.people_alt),
            title: const Text('Produk'),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
          ),
        ),
        Card(
          color: Theme.of(context).colorScheme.surface,
          child: ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Pengaturan Akun'),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
            onTap: () {
              Navigator.of(context).pop();
              nextPage(context, "${AppRoutes.admin}/profile/setting");
            },
          ),
        ),
      ],
    );
  }
}
