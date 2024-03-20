import 'package:flutter/material.dart';

class ProfileWithName extends StatelessWidget {
  final String? name;
  final double? radius;

  const ProfileWithName(this.name, {super.key, this.radius});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius ?? 20,
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Colors.white,
      child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            name?.substring(0, 2).toUpperCase() ?? "",
            style: const TextStyle(fontSize: 45),
          )),
    );
  }
}
