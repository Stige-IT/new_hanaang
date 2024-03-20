import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../config/router/router_config.dart';
import '../../../../../features/bank-account/provider/bank-account_provider.dart';
import '../../../../../features/hutang/provider/hutang_provider.dart';
import '../../../../components/card_total.dart';
import '../../../../components/navigation_widget.dart';

class CardBankSaldoWidget extends ConsumerWidget {
  const CardBankSaldoWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int? totalHutang = ref.watch(totalHutangNotifier).data;
    final totalSaldo = ref.watch(bankSaldoNotifier);
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Theme.of(context).colorScheme.surface,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      child: SizedBox(
        height: 100,
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CardTotal(
                title: "Total Saldo",
                value: totalSaldo,
                onTap: () => nextPage(
                  context,
                  '${AppRoutes.sa}/finance/bank',
                ),
              ),
              const SizedBox(
                height: 50,
                child: VerticalDivider(
                  color: Colors.black26,
                  thickness: 2,
                ),
              ),
              CardTotal(
                title: "Total Hutang",
                value: totalHutang ?? 0,
                onTap: () => nextPage(context, "${AppRoutes.sa}/hutang"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
