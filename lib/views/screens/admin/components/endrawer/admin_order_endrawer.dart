
import 'package:flutter/material.dart';

import '../../../../../config/router/router_config.dart';
import '../../../../components/navigation_widget.dart';

class AdminOrderEndrawer extends StatelessWidget {
  const AdminOrderEndrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          color: Theme.of(context).colorScheme.surface,
          child: ListTile(
            onTap: () {
              Navigator.pop(context);
              nextPage(context, "${AppRoutes.admin}/setting-pre-order");
            },
            leading: const Icon(Icons.settings_applications),
            title: const Text('Setting Pre Order'),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
          ),
        ),
        Card(
          color: Theme.of(context).colorScheme.surface,
          child: ListTile(
            onTap: () {
              Navigator.pop(context);
              nextPage(context, "${AppRoutes.admin}/pre-order");
            },
            leading: const Icon(Icons.shopping_bag),
            title: const Text('Pre Order'),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
          ),
        ),
        Card(
          color: Theme.of(context).colorScheme.surface,
          child: ListTile(
            onTap: () {
              Navigator.pop(context);
              nextPage(context, "${AppRoutes.admin}/order-page");
            },
            leading: const Icon(Icons.shopping_cart_rounded),
            title: const Text('Pesanan'),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
          ),
        ),
        Card(
          color: Theme.of(context).colorScheme.surface,
          child: ListTile(
            onTap: () {
              Navigator.pop(context);
              nextPage(context, "${AppRoutes.admin}/retur");
            },
            leading: const Icon(Icons.shopping_cart_checkout),
            title: const Text('Retur'),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
          ),
        ),
        Card(
          color: Theme.of(context).colorScheme.surface,
          child: ListTile(
            onTap: () {
              Navigator.pop(context);
              nextPage(context, "${AppRoutes.admin}/shopping");
            },
            leading: const Icon(Icons.note_alt),
            title: const Text('Belanja'),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
          ),
        ),
        Card(
          color: Theme.of(context).colorScheme.surface,
          child: ListTile(
            leading: const Icon(Icons.people_alt),
            title: const Text('Pengguna'),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
            onTap: () {
              Navigator.of(context).pop();
              nextPage(context, "${AppRoutes.admin}/user-hanaang");
            },
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
