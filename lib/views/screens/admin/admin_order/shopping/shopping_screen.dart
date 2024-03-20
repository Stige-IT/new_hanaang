import 'package:admin_hanaang/config/router/router_config.dart';
import 'package:admin_hanaang/features/shopping/provider/shopping_provider.dart';
import 'package:admin_hanaang/views/components/appbar_admin.dart';
import 'package:admin_hanaang/views/components/navigation_widget.dart';
import 'package:admin_hanaang/views/screens/admin/admin_order/shopping/widgets/detail_shopping.dart';
import 'package:admin_hanaang/views/screens/admin/admin_order/shopping/widgets/listview_shopping.dart';
import 'package:admin_hanaang/views/screens/admin/components/endrawer/endrawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShoppingScreenAo extends ConsumerStatefulWidget {
  const ShoppingScreenAo({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ShoppingScreenAoState();
}

class _ShoppingScreenAoState extends ConsumerState<ShoppingScreenAo> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late ScrollController _scrollController;

  @override
  void initState() {
    Future.microtask(() => ref.read(shoppingsNotifier.notifier).getData());
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          int currentPage = ref.watch(shoppingsNotifier).page;
          int lastPage = ref.watch(shoppingsNotifier).lastPage;
          if (currentPage < lastPage) {
            ref.read(shoppingsNotifier.notifier).loadMore();
          }
        }
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: const EndrawerWidget(),
      appBar: AppbarAdmin(
        scaffoldKey: _scaffoldKey,
        title: "Daftar Belanja Barang",
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => nextPage(context, '${AppRoutes.admin}/shopping/form'),
        label: const Text("Pengeluaran baru"),
        icon: const Icon(Icons.add),
      ),
      body: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Left Screen -> list view screen history shopping
          ListViewShopping(),

          VerticalDivider(),

          //Right screen -> detail shopping data
          DetailShopping(),
        ],
      ),
    );
  }
}
