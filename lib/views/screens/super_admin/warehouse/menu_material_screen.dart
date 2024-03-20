import 'package:admin_hanaang/config/router/router_config.dart';
import 'package:admin_hanaang/config/theme.dart';
import 'package:admin_hanaang/views/components/navigation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuMaterialScreen extends ConsumerWidget {
  const MenuMaterialScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text("Menu"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(15.0),
        children: [
          Card(
            color: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              leading: const Icon(Icons.inventory),
              title: const Text("Bahan Baku"),
              onTap: ()=> nextPage(context, "${AppRoutes.sa}/materials"),
            ),
          ),
          Card(
            color: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              leading: const Icon(Icons.abc),
              title: const Text("Unit Satuan"),
              onTap: ()=> nextPage(context, "${AppRoutes.sa}/units"),
            ),
          ),
          Card(
            color: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              leading: const Icon(Icons.receipt_long),
              title: const Text("Penerimaan Barang"),
              onTap: ()=> nextPage(context, "${AppRoutes.sa}/penerimaan-barang"),
            ),
          ),
        ],
      ),
    );
  }
}
