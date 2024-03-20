import 'package:flutter/material.dart';

class ErrorButtonWidget extends StatelessWidget {
  final String errorMsg;
  final void Function()? onTap;
  const ErrorButtonWidget({
    super.key,
    required this.errorMsg,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.refresh),
        label: Text(errorMsg),
      ),
    );
  }
}
