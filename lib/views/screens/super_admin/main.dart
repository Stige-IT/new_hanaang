
import 'dart:developer';
import 'package:admin_hanaang/features/pre-order/provider/pre_order_provider.dart';
import 'package:admin_hanaang/features/pre_order_users/provider/pre_order_user_provider.dart';
import 'package:admin_hanaang/features/retur/provider/retur_provider.dart';
import 'package:admin_hanaang/features/users_hanaang/provider/users_hanaang_providers.dart';
import 'package:admin_hanaang/views/screens/super_admin/account/account_screen.dart';
import 'package:admin_hanaang/views/screens/super_admin/employee/employee_screen.dart';
import 'package:admin_hanaang/views/screens/super_admin/home/home_screen.dart';
import 'package:admin_hanaang/views/screens/super_admin/users/users_screen.dart';
import 'package:admin_hanaang/views/screens/super_admin/warehouse/warehouse_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../features/order/order.dart';
import 'order/order.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  @override
  void initState() {
    Future.microtask(() async {
      FirebaseMessaging fcmMessage = FirebaseMessaging.instance;
      await fcmMessage
          .subscribeToTopic('super-admin')
          .then((value) => log("Notification started => super-admin"));
      FirebaseMessaging.onMessage.listen((message) {
        log("message Type : ${message.data}");
        // NotificationService().shoNotification(
        //   title: "MAIN ${message.notification!.title}",
        //   body: message.notification!.body,
        // );
        switch (message.data['type']) {
          case "new-user":
            log("Notification New User");
            ref.watch(totalUserNotifier.notifier).getTotal();
            ref
                .watch(userNotifier.notifier)
                .getData(role: "User", makeLoading: true);

            break;
          case "pre-order":
            log("Notification New order");
            ref.read(preOrderUsersNotifierProvider.notifier).getPreOrderUsers();
            ref.read(preOrderNotifierProvider.notifier).getPreOrder();
            break;
          case "retur":
            log("Notification New retur");
            ref.read(returProcessNotifier);
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final int index = ref.watch(navProvider);
    return Scaffold(
      body: IndexedStack(
        index: index,
        children: const [
          HomeScreen(),
          OrderScreen(),
          WarehouseScreen(),
          UsersScreen(),
          EmployeeScreen(),
          AccountScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 5,
        currentIndex: index,
        backgroundColor: Theme.of(context).colorScheme.primary,
        unselectedFontSize: 8.sp,
        selectedFontSize: 10.sp,
        iconSize: 20,
        selectedItemColor: Theme.of(context).colorScheme.background,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: "Pesanan"),
          BottomNavigationBarItem(
              icon: Icon(Icons.reset_tv_rounded), label: "Gudang"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Pengguna"),
          BottomNavigationBarItem(
              icon: Icon(Icons.emoji_people), label: "karyawan"),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: "Akun"),
        ],
        onTap: ref.watch(navProvider.notifier).changeNavigation,
      ),
    );
  }
}

final navProvider = StateNotifierProvider<NavigationNotifier, int>((ref) {
  return NavigationNotifier();
});

class NavigationNotifier extends StateNotifier<int> {
  NavigationNotifier() : super(0);

  changeNavigation(int newIndex) => state = newIndex;
}
