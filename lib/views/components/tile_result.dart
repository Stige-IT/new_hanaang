import 'package:flutter/material.dart';

class TileResult extends StatelessWidget {
  final String value;
  final String title;
  final bool? isHeading;
  const TileResult({
    super.key,
    required this.value,
    required this.title,
    this.isHeading,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: const VisualDensity(vertical: -4),
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: TextStyle(fontSize: isHeading != null && isHeading! ? 20 : 14),
      ),
      trailing: Text(value,
          style: TextStyle(
              fontSize: isHeading != null && isHeading! ? 20 : 14,
              fontWeight: FontWeight.bold)),
    );
  }
}
