import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/user/provider/user_provider.dart';

class AppbarAdmin extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  const AppbarAdmin({
    super.key,
    this.isMain,
    this.title,
    required GlobalKey<ScaffoldState> scaffoldKey,
  }) : _scaffoldKey = scaffoldKey;

  final String? title;
  final GlobalKey<ScaffoldState> _scaffoldKey;
  final bool? isMain;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AppbarAdminOrderState();

  @override
  Size get preferredSize => const Size.fromHeight(50.0);
}

class _AppbarAdminOrderState extends ConsumerState<AppbarAdmin> {
  @override
  Widget build(BuildContext context) {
    final dataUser = ref.watch(userNotifierProvider).data;
    return AppBar(
      elevation: 0,
      leadingWidth: 120,
      leading: Row(
        children: [
          if(widget.isMain == null)
          const BackButton(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
            child: Image.asset("assets/components/logo_hanaang.png"),
          )
        ],
      ),
      centerTitle: true,
      title: Text(
        widget.title ?? "TEH TARIK HANAANG",
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        InkWell(
          onTap: () {
            FocusScope.of(context).unfocus();
            widget._scaffoldKey.currentState!.openEndDrawer();
          },
          child: Row(
            children: [
              const Icon(Icons.account_circle),
              const SizedBox(width: 10),
              Align(
                alignment: Alignment.center,
                child: Text(
                  dataUser?.name ?? 'Admin',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        )
      ],
    );
  }
}
