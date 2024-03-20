import 'package:flutter/material.dart';

class Label extends StatelessWidget {
  final String? status;
  final String? title;
  const Label({super.key, this.status, this.title});

  @override
  Widget build(BuildContext context) {
    setstatus() {
      switch (status) {
        case "not":
          return Colors.red;
        case "partial":
          return Colors.orange;
        case "done":
          return Colors.green;
        default:
          return Colors.black;
      }
    }

    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: setstatus(),
        borderRadius: BorderRadius.circular(10),
      ),
      child: FittedBox(
        child: Text(
          title!,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
