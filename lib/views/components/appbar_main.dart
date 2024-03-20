import 'package:flutter/material.dart';

class AppbarMain extends StatelessWidget implements PreferredSizeWidget{
  final String title;
  final List<Widget>? actions;
  const AppbarMain(this.title,{super.key, this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      title: Text(title),
      actions: actions ?? [],
    );
  }

  @override
  Size get preferredSize => throw UnimplementedError();

}
