import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/theme.dart';

class DropdownContainer<T> extends StatelessWidget {
  final List<DropdownMenuItem<T?>>? items;
  final double? itemHeight;
  final void Function(T?)? onChanged;
  final String? title;
  final String? hint;
  final T? value;

  const DropdownContainer({
    super.key,
    required this.items,
    required this.onChanged,
    this.title,
    this.hint,
    this.value,
    this.itemHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Text(
              "$title",
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(1, 1),
                  blurRadius: 2,
                  spreadRadius: 2,
                )
              ],
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T?>(
                itemHeight: itemHeight ?? kMinInteractiveDimension,
                value: value,
                style: Theme.of(context).textTheme.bodySmall,
                hint: Text(
                  hint ?? "Silahkan pilih $title",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                isExpanded: true,
                borderRadius: BorderRadius.circular(15.r),
                items: items,
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
