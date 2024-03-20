import 'package:admin_hanaang/utils/helper/formatted_currency.dart';
import 'package:flutter/material.dart';

class CardUsers extends StatelessWidget {
  final int? total;
  final String title;
  final void Function()? onTap;
  const CardUsers({
    super.key,
    this.total,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    String value = total.toString();
    return InkWell(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        elevation: 2,
        color: Theme.of(context).colorScheme.primary,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (total != null)
              Text(
                formatNumber(value),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.background,
                ),
              ),
            Text(
              title,
              textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Theme.of(context).colorScheme.background,
                  fontWeight: FontWeight.bold,
                ),
            ),
          ],
        ),
      ),
    );
  }
}
