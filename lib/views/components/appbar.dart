import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/theme.dart';

class AppBarSliver extends StatelessWidget {
  final Widget? image;
  final String? title;
  final List<Widget>? actions;

  const AppBarSliver({
    super.key,
    this.title,
    this.image,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      collapsedHeight: 100.h,
      expandedHeight: 120.h,
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.primary,
      stretch: true,
      pinned: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50.r),
          bottomRight: Radius.circular(50.r),
        ),
      ),
      actions: actions ?? [],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.all(10),
        expandedTitleScale: 1.5,
        centerTitle: true,
        collapseMode: CollapseMode.parallax,
        title: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              image ??
                  Image.asset(
                    "assets/components/logo_hanaang.png",
                    height: 40,
                    fit: BoxFit.fitWidth,
                  ),
              // const SizedBox(height: 5),
              if (title != null)
                Text(title!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    )),
            ],
          ),
        ),
        background: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50.r),
            bottomRight: Radius.circular(50.r),
          ),
          child: Image.asset("assets/components/header.png", fit: BoxFit.cover),
        ),
      ),
    );
  }
}
