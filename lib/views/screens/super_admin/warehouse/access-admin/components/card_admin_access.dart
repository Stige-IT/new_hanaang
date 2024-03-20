import 'package:flutter/material.dart';

class CardAdminAccess extends StatelessWidget {
  final String title;
  final IconData icon;
  final void Function() onTap;
  const CardAdminAccess({
    super.key, required this.title, required this.icon, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 7.0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)),
      color: Colors.grey[300],
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(15.0),
        title: Icon(
          icon,
          size: 40,
          color: Colors.black,
        ),
        subtitle: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}