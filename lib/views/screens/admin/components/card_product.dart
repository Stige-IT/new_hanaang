import 'package:flutter/material.dart';

import '../../../../utils/helper/formatted_currency.dart';

class CardProduct extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const CardProduct({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 3),
      ),
      elevation: 2,
      child: Center(
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon),
              const SizedBox(width: 5),
              Text(title, textAlign: TextAlign.center),
            ],
          ),
          subtitle: Text(
            "${formatNumber(value)} Cup",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
