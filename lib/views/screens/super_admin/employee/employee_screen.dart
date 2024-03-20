import 'package:admin_hanaang/config/router/router_config.dart';
import 'package:admin_hanaang/views/components/navigation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../components/appbar.dart';
import '../../../components/tile.dart';

class EmployeeScreen extends ConsumerStatefulWidget {
  const EmployeeScreen({super.key});

  @override
  ConsumerState createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends ConsumerState<EmployeeScreen> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1), () {
          // getDataUsersHanaang();
        });
      },
      child: Scaffold(
        body: CustomScrollView(slivers: [
          const AppBarSliver(),
          SliverList(
              delegate: SliverChildListDelegate([
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                children: [
                  Tile(
                    title: "Daftar Karyawan",
                    onTap: () => nextPage(
                      context,
                      "${AppRoutes.sa}/employee/list",
                    ),
                  ),
                  Tile(
                    title: "Jabatan",
                    onTap: () => nextPage(context, '/positions'),
                  ),
                  Tile(
                    title: "Gaji Karyawan",
                    onTap: () {},
                  ),
                ],
              ),
            )
          ]))
        ]),
      ),
    );
  }
}
