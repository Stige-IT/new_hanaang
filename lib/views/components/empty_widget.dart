import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.no_stroller, color: Theme.of(context).colorScheme.primary, size: 50),
          const SizedBox(height: 10),
          const Text("Belum ada data"),
        ],
      ),
    );
  }
}
