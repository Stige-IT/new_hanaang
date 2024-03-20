import 'package:admin_hanaang/utils/extensions/date_formater.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FormDatetimeWidget extends StatelessWidget {
  final String title;
  final String selectedDatetime;
  final void Function()? onTap;

  const FormDatetimeWidget({
    super.key,
    required this.title,
    required this.selectedDatetime,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 5.0.h),
            padding: EdgeInsets.symmetric(horizontal: 10.0.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.r),
              border: Border.all(color: Colors.orange),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedDatetime.timeFormat(),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                IconButton(
                  onPressed: onTap,
                  icon: const Icon(Icons.date_range),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
