import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import '../../../../../features/suplayer/provider/suplayer_provider.dart';
import '../../../../components/snackbar.dart';

void dialogDelete(context, WidgetRef ref,
    {required String suplayerId, bool? isDetailPage = false}) {
  PanaraConfirmDialog.show(
    context,
    message: "Hapus suplayer ini?",
    confirmButtonText: "Hapus",
    cancelButtonText: "Kembali",
    onTapConfirm: () {
      Navigator.of(context).pop();
      ref
          .read(deleteSuplayerNotifier.notifier)
          .deleteSuplayer(suplayerId)
          .then((success) {
        if (success) {
          if (isDetailPage!) {
            Navigator.of(context).pop();
          }
        } else {
          final msg = ref.watch(deleteSuplayerNotifier).error;
          showSnackbar(context, msg!, isWarning: true);
        }
      });
    },
    onTapCancel: Navigator.of(context).pop,
    panaraDialogType: PanaraDialogType.error,
  );
}
