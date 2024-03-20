import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DialogWidget extends StatelessWidget {
  final String? title;
  final List<Widget>? content;
  final List<Widget>? action;
  final bool? isBarrierDismissible;

  const DialogWidget({
    super.key,
    this.title,
    this.content = const [],
    this.action = const [],
    this.isBarrierDismissible = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isBarrierDismissible!) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            margin: EdgeInsets.all(20.0.h),
            padding: EdgeInsets.all(20.0.h),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListView(
              shrinkWrap: true,
              children: [
                if (title != null)
                  ListTile(
                    visualDensity: VisualDensity.compact,
                    contentPadding: EdgeInsets.zero,
                    title: Text(title!,
                        style: Theme.of(context).textTheme.bodySmall),
                    trailing: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ),
                if (title != null) const Divider(),

                /// [children widget]
                Column(children: content!),

                /// [action button]
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: action!,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
