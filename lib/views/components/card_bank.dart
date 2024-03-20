import 'package:admin_hanaang/config/router/router_config.dart';
import 'package:admin_hanaang/config/theme.dart';
import 'package:admin_hanaang/utils/extensions/currency_format.dart';
import 'package:admin_hanaang/views/components/label.dart';
import 'package:admin_hanaang/views/components/navigation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../models/bank_account.dart';

class CardBank extends ConsumerStatefulWidget {
  final BankAccount account;

  const CardBank({
    super.key,
    required this.account,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CardBankState();
}

class _CardBankState extends ConsumerState<CardBank> {
  @override
  Widget build(BuildContext context) {
    final bool isPrimary = widget.account.primary == '1';
    return InkWell(
      onTap: () {
        nextPage(context, "${AppRoutes.sa}/finance", argument: widget.account);
        // _dialogNewAccountBank(context);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(
            color: isPrimary
                ? Colors.green
                : Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        color: Theme.of(context).colorScheme.surface,
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  SvgPicture.asset("assets/components/money.svg"),
                  const SizedBox(height: 10),
                  Text(
                    "${int.parse(widget.account.ballance!).convertToIdr()}",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    widget.account.bankName!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              if (isPrimary)
                const Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                      height: 30,
                      width: 60,
                      child: Label(status: 'done', title: "Primary")),
                )
            ],
          ),
        ),
      ),
    );
  }
}
