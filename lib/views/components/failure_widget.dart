import 'package:flutter/material.dart';

class FailureWidget extends StatelessWidget {
  final String error;
  final void Function()? onPressed;
  const FailureWidget({super.key, required this.error, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: onPressed ?? () {},
          icon: const Icon(Icons.refresh_rounded),
        ),
        const SizedBox(height: 5),
        Text(error),
      ],
    ));
  }
}
