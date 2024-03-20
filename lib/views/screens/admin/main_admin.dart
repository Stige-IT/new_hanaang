import 'dart:developer';

import 'package:admin_hanaang/config/constant/role_id.dart';
import 'package:admin_hanaang/config/router/router_config.dart';
import 'package:admin_hanaang/features/user/provider/user_provider.dart';
import 'package:admin_hanaang/models/manage_access.dart';
import 'package:admin_hanaang/views/components/navigation_widget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/manage_access_warehouse/provider/manage_accces_provider.dart';
import '../../../features/order/order.dart';
import '../../../features/pre_order_users/provider/pre_order_user_provider.dart';
import '../../../features/stock/provider/stock_provider.dart';

class MainAdmin extends ConsumerStatefulWidget {
  const MainAdmin({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainAdminState();
}

class _MainAdminState extends ConsumerState<MainAdmin> {
  _getProductInfo() {
    ref.watch(totalOrderNotifier.notifier).getTotalOrders();
    ref.watch(remainingStockNotifier.notifier).getStock();
    ref.watch(soldStockNotifier.notifier).getStock();
    ref.watch(returStockNotifier.notifier).getStock();
  }

  _initFirebaseMessgeWithTopic(FirebaseMessaging fcm, String topic) async {
    await fcm
        .subscribeToTopic(topic)
        .then((value) => log("Notification started => $topic"));
  }

  @override
  void initState() {
    Future.microtask(() async {
      _getProductInfo();
      ref.read(userNotifierProvider.notifier).getProfile();

      await ref.read(manageAccessNotifier.notifier).getData();
      await ref.read(roleNotifier.notifier).getRole();
      final role = ref.watch(roleNotifier);

      if (role != null) {
        final fcm = FirebaseMessaging.instance;
        FirebaseMessaging.onMessage.listen((message) {
          log(message.toString());
          switch (message.data['type']) {
            case "pre-order":
              log("Notification New order");
              ref
                  .watch(preOrderUsersNotifierProvider.notifier)
                  .getPreOrderUsers();
          }
        });

        if (role == RoleAdmin.adminOrder.value) {
          await _initFirebaseMessgeWithTopic(fcm, "admin-order");
          if (!mounted) return;
          nextPageRemove(context, "${AppRoutes.admin}/order");
        } else {
          await _initFirebaseMessgeWithTopic(fcm, "admin-gudang");

          // Generate next navigation with access read first
          await getNextNavigation();
          List<String> list = ref.watch(tempAccessNotifier);
          print(list);
          if (list.isNotEmpty) {
            if (!mounted) return;
            log("FIRST ${list.first}");
            log("LAST ${list.last}");
            switch (list.first) {
              case "Suplayer":
                nextPageRemove(context, "${AppRoutes.admin}/suplayer");
                break;
              case "Bahan Baku":
                nextPageRemove(context, "${AppRoutes.admin}/material");
                break;
              case "Penerimaan Barang":
                nextPageRemove(context, "${AppRoutes.admin}/penerimaan-barang");
                break;
              case "Unit":
                nextPageRemove(context, "${AppRoutes.admin}/units");
                break;
              case "Resep":
                nextPageRemove(context, "${AppRoutes.admin}/recipt");
                break;
              default:
                nextPageRemove(context, "/login");
            }
          }
        }
      }
    });
    super.initState();
  }

  Future<List<String>> getNextNavigation() async {
    log("MANAGE ACCESS");
    final manageAccess = ref.read(manageAccessNotifier);
    List<String> temp = ref.watch(tempAccessNotifier);
    for (ManageAccess access in manageAccess.data ?? []) {
      if (access.read == "1") {
        log(access.categoryAccess!);
        ref.read(tempAccessNotifier.notifier).add(access.categoryAccess!);
      }
    }
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset("assets/components/logo_hanaang.png"),
      ),
    );
  }
}

final tempAccessNotifier =
    StateNotifierProvider.autoDispose<TempAccessNotifier, List<String>>((ref) {
  return TempAccessNotifier();
});

class TempAccessNotifier extends StateNotifier<List<String>> {
  TempAccessNotifier() : super([]);

  void add(String item) {
    state = [item, ...state];
  }
}
