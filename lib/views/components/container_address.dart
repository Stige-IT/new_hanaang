import 'package:flutter/material.dart';

class ContainerAddress extends StatelessWidget {
  final String? label;
  final String? value;
  final bool? isMultiLine;
  const ContainerAddress({super.key, this.label, this.value, this.isMultiLine});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: TextEditingController(text: value ?? "-"),
        readOnly: true,
        keyboardType: isMultiLine != null && isMultiLine!
            ? TextInputType.multiline
            : null,
        maxLines: isMultiLine != null && isMultiLine! ? 3 : null,
        decoration: InputDecoration(
            label: label != null ? Text(label!) : null,
            labelStyle: const TextStyle(fontSize: 16),
            border: const OutlineInputBorder(),
            enabledBorder: const OutlineInputBorder()),
      ),
    );
  }
}
