import 'package:admin_hanaang/config/router/router_config.dart';
import 'package:admin_hanaang/features/manage_access_warehouse/provider/manage_accces_provider.dart';
import 'package:admin_hanaang/features/shift/shift.dart';
import 'package:admin_hanaang/features/user/provider/user_provider.dart';
import 'package:admin_hanaang/models/user.dart';
import 'package:admin_hanaang/views/components/circle_avatar_network.dart';
import 'package:admin_hanaang/views/components/navigation_widget.dart';
import 'package:admin_hanaang/views/components/profile_with_name.dart';
import 'package:admin_hanaang/views/screens/admin/components/dialog_logout.dart';
import 'package:admin_hanaang/views/screens/admin/components/endrawer/admin_gudang_endrawer.dart';
import 'package:admin_hanaang/views/screens/admin/components/endrawer/admin_order_endrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../utils/constant/base_url.dart';
import '../../../../../config/constant/role_id.dart';
import '../../../../components/snackbar.dart';

class EndrawerWidget extends ConsumerWidget {
  const EndrawerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roleUser = ref.watch(roleNotifier);
    final isAdminOrder = roleUser == RoleAdmin.adminOrder.value;
    final isAdminGudang = roleUser == RoleAdmin.adminGudang.value;
    final isAdminGudang2 = roleUser == RoleAdmin.adminGudang2.value;
    final isAdminGudang3 = roleUser == RoleAdmin.adminGudang3.value;
    final User? user = ref.watch(userNotifierProvider).data;
    Size size = MediaQuery.of(context).size;
    return RefreshIndicator(
      onRefresh: () async{
        await Future.delayed(const Duration(seconds: 1),(){
          ref.read(userNotifierProvider.notifier).getProfile();
          ref.read(roleNotifier.notifier).getRole();
          ref.read(manageAccessNotifier.notifier).getData();
        });
      },
      child: Drawer(
        width: size.width * 0.4,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  nextPage(context, "${AppRoutes.admin}/profile");
                },
                child: Card(
                  color: Theme.of(context).colorScheme.surface,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    alignment: Alignment.center,
                    height: size.height * 0.25,
                    child: ListTile(
                      leading: user?.image == null
                          ? ProfileWithName(user?.name ?? "  ", radius: 40)
                          : CircleAvatarNetwork(
                              "$BASE/${user!.image}",
                              radius: 60,
                            ),
                      title: Text(
                        user?.name ?? "...",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      subtitle: const Text(""), /// TODO : add role
                    ),
                  ),
                ),
              ),

              // condition endrawer with role admin
              if (isAdminOrder)
                const AdminOrderEndrawer()
              else if (isAdminGudang || isAdminGudang2 || isAdminGudang3)
                const AdminGudangEndrawer(),

              Card(
                color: Theme.of(context).colorScheme.surface,
                child: ListTile(
                  onTap: (){
                    ref.watch(closeShiftNotifier.notifier).close().then((success) {
                      if(success){
                        nextPageRemoveAll(context, "/admin/shift");
                      }else{
                        final err = ref.watch(closeShiftNotifier).error;
                        showSnackbar(context, err!, isWarning: true);
                      }
                    });
                  },
                  leading: const Icon(Icons.punch_clock_outlined, color: Colors.red),
                  title:
                  const Text('Tutup Shift', style: TextStyle(color: Colors.red)),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded,
                      color: Colors.red),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                color: Theme.of(context).colorScheme.surface,
                child: ListTile(
                  onTap: ()=> dialogLogout(context, ref),
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title:
                      const Text('Keluar', style: TextStyle(color: Colors.red)),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded,
                      color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
