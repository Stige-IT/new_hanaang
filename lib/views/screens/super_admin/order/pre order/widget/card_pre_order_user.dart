import 'package:admin_hanaang/config/router/router_config.dart';
import 'package:admin_hanaang/utils/extensions/currency_format.dart';
import 'package:admin_hanaang/utils/extensions/date_formater.dart';
import 'package:admin_hanaang/views/components/circle_avatar_network.dart';
import 'package:admin_hanaang/views/components/navigation_widget.dart';
import 'package:admin_hanaang/views/components/profile_with_name.dart';
import 'package:flutter/material.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import '../../../../../../config/theme.dart';
import '../../../../../../models/pre_order_user.dart';
import '../../../../../../utils/constant/base_url.dart';

class CardPreOrderUser extends StatelessWidget {
  const CardPreOrderUser({
    super.key,
    required this.data,
  });

  final PreOrderUser data;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        PanaraConfirmDialog.show(
          context,
          message: "Jadikan Pre Order sebagai Pesanan?",
          confirmButtonText: "Ya",
          cancelButtonText: "Kembali",
          onTapConfirm: () {
            Navigator.pop(context);
            nextPage(
              context,
              "${AppRoutes.sa}/pre-order-list/detail",
              argument: data,
            );
          },
          onTapCancel: () => Navigator.pop(context),
          panaraDialogType: PanaraDialogType.warning,
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Theme.of(context).colorScheme.surface,
        child: Column(
          children: [
            ListTile(
              // visualDensity: const VisualDensity(vertical: -4),
              leading: data.user?.image == null
                  ? ProfileWithName(data.user!.name!)
                  : CircleAvatarNetwork("$BASE/${data.user!.image}"),
              title: Text(
                data.user!.name!,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                data.user!.email!,
                style: const TextStyle(
                    fontSize: 12, overflow: TextOverflow.ellipsis),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Total Pesanan",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    "${data.quantity} Cup",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      // fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.poNumber!,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        data.createdAt!.dateFormatWithDay(),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Harga : ${(data.price!).convertToIdr()}",
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        "Total Harga : ${(data.totalPrice!).convertToIdr()}",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
