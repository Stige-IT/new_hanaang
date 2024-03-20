import 'package:flutter/material.dart';

class ButtonTypeOrder extends StatelessWidget {
  final bool isSelected;
  final String title;
  final void Function()? onPressed;
  const ButtonTypeOrder({
    super.key,
    required this.title,
    required this.isSelected,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          foregroundColor: isSelected ? Colors.white : Theme.of(context).colorScheme.primary,
          elevation: isSelected ? 2 : 0,
          backgroundColor: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: isSelected
                ? BorderSide.none
                : BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
          ),
        ),
        onPressed: onPressed ?? () {},
        child: Text(title),
      ),
    );
  }
}
