import 'package:admin_hanaang/config/router/router_config.dart';
import 'package:admin_hanaang/config/theme.dart';
import 'package:admin_hanaang/utils/extensions/currency_format.dart';
import 'package:admin_hanaang/utils/extensions/date_formater.dart';
import 'package:admin_hanaang/views/components/navigation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CardIncome extends StatelessWidget {
  final String historyBankId;
  final bool isIncome;
  final String type;
  final String nominal;
  final String createdAt;
  const CardIncome({
    super.key,
    required this.isIncome,
    required this.type,
    required this.nominal,
    required this.createdAt,
    required this.historyBankId,
  });

  @override
  Widget build(BuildContext context) {
    final String assetName = isIncome ? "price" : "deposit";
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Theme.of(context).colorScheme.surface,
      elevation: 3,
      child: ListTile(
        onTap: () => nextPage(
            context, "${AppRoutes.sa}/finance/bank/history/detail",
            argument: {
              'bankHistoryId': historyBankId,
              "is_income": isIncome,
            }),
        leading: SvgPicture.asset(
          "assets/components/$assetName.svg",
        ),
        title: Text(type,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            )),
        subtitle: Text(createdAt.dateFormatWithDay(),
            style: const TextStyle(fontSize: 12)),
        trailing: Text(int.parse(nominal).convertToIdr(),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            )),
      ),
    );
  }
}
