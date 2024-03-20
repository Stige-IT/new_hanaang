import 'package:admin_hanaang/views/components/appbar_admin.dart';
import 'package:admin_hanaang/views/screens/admin/components/endrawer/endrawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widget/form_user.dart';

class FormUserHanaangScreenAo extends ConsumerStatefulWidget {
  const FormUserHanaangScreenAo({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FormUserHanaangScreenAoState();
}

class _FormUserHanaangScreenAoState
    extends ConsumerState<FormUserHanaangScreenAo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppbarAdmin(
            scaffoldKey: _scaffoldKey, title: "Pendaftaran Pengguna baru"),
        endDrawer: const EndrawerWidget(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: SizedBox(
              width: size.width * 0.5,
              child: const FormUser(),
            ),
          ),
        ));
  }
}
