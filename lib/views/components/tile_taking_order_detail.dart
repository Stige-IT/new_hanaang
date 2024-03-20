import 'package:admin_hanaang/utils/extensions/date_formater.dart';
import 'package:flutter/material.dart';

import '../../models/taking_order.dart';

class TilePaymentDetailTakeOrder extends StatelessWidget {
  const TilePaymentDetailTakeOrder({
    super.key,
    required this.takingOrder,
  });

  final TakingOrder takingOrder;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.local_drink_rounded, color: Colors.green),
        title: Text("Diambil : ${takingOrder.quantity} Cup"),
        subtitle: Text("Oleh ${takingOrder.createdBy!.name}"),
        trailing: Text(
          "${takingOrder.createdAt.toString().timeFormat()} WIB",
          style: const TextStyle(fontSize: 10),
        ),
      ),
    );
  }
}
