
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import '../../../../config/constant/role_id.dart';
import '../../../../features/auth/provider/auth_provider.dart';
import '../../../../features/shift/shift.dart';
import '../../../../features/user/provider/user_provider.dart';
import '../../../components/navigation_widget.dart';

void dialogLogout(context, WidgetRef ref, ) {
  final apiAuth = ref.watch(authNotifier.notifier);
  PanaraConfirmDialog.show(context,
      message: "Yakin keluar",
      confirmButtonText: "Keluar",
      cancelButtonText: "Kembali",
      onTapConfirm: () async {
        ref.watch(closeShiftNotifier.notifier).close();
        nextPageRemoveAll(context, '/login');
        FirebaseMessaging fcmMessage = FirebaseMessaging.instance;
        final role = ref.watch(roleNotifier);
        if (role == RoleAdmin.adminGudang.value) {
          log("admin gudang");
          await fcmMessage.unsubscribeFromTopic('admin-gudang').then((value) {
            log("UNSUNSCRIBE ADMIN GUDANG");
            ref.invalidate(roleNotifier);
          });
        } else if (role == RoleAdmin.adminOrder.value) {
          log("admin order");
          await fcmMessage.unsubscribeFromTopic('admin-order').then((value) {
            log("UNSUNSCRIBE ADMIN ORDER");
            ref.invalidate(roleNotifier);
          });
        }
        if (!context.mounted) return;
        apiAuth.logout();
      },
      onTapCancel: () => Navigator.of(context).pop(),
      panaraDialogType: PanaraDialogType.error);
}