import 'package:admin_hanaang/utils/extensions/currency_format.dart';
import 'package:flutter/material.dart';

class CardTotal extends StatelessWidget {
  final String title;
  final int value;
  final void Function()? onTap;

  const CardTotal({
    super.key,
    required this.title,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListTile(
        onTap: onTap ?? () {},
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        subtitle: Text(
          value.convertToIdr(),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
