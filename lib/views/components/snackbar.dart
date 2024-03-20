import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

showSnackbar(BuildContext context, String message, {bool? isWarning}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: isWarning == null ? Colors.green : Colors.red,
      content: Text(
        message,
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Theme.of(context).colorScheme.background,
            ),
      ),
    ),
  );
}
