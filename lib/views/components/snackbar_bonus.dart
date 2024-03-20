import 'package:flutter/material.dart';

class SnackbarBonus extends StatelessWidget {
  final String value;
  const SnackbarBonus({
    super.key,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.green,
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        leading: const Icon(
          Icons.sentiment_very_satisfied_rounded,
          color: Colors.white,
        ),
        title: Text(
          value,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
