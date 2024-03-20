import 'package:flutter/material.dart';

import '../../config/theme.dart';

class RoundedButton extends StatelessWidget {
  final bool isSelected;
  final String title;
  final void Function()? onTap;

  const RoundedButton({
    super.key,
    required this.isSelected,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap ?? () {},
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(15.0),
        margin: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.primary : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Theme.of(context).colorScheme.primary),
          boxShadow: [
            BoxShadow(
              offset: const Offset(1, 1),
              color: Colors.black.withOpacity(0.2),
              blurRadius: 3,
            )
          ]
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
