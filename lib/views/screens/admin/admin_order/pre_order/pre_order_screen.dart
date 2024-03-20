import 'package:admin_hanaang/utils/extensions/currency_format.dart';
import 'package:admin_hanaang/utils/extensions/date_formater.dart';
import 'package:admin_hanaang/views/components/appbar_admin.dart';
import 'package:admin_hanaang/views/components/circle_avatar_network.dart';
import 'package:admin_hanaang/views/components/error_button_widget.dart';
import 'package:admin_hanaang/views/components/loading_in_button.dart';
import 'package:admin_hanaang/views/components/profile_with_name.dart';
import 'package:admin_hanaang/views/screens/admin/components/endrawer/endrawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import '../../../../../config/router/router_config.dart';
import '../../../../../features/pre_order_users/provider/pre_order_user_provider.dart';
import '../../../../../models/pre_order_user.dart';
import '../../../../../utils/constant/base_url.dart';
import '../../../../components/navigation_widget.dart';

final searchNotifier = StateProvider<List<PreOrderUser>?>((ref) => []);

class PreOrderScreenAO extends ConsumerStatefulWidget {
  const PreOrderScreenAO({super.key});

  @override
  ConsumerState createState() => _PreOrderScreenAOState();
}

class _PreOrderScreenAOState extends ConsumerState<PreOrderScreenAO> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  late TextEditingController _searchCtrl;

  @override
  void initState() {
    Future.microtask(() async {
      await ref
          .watch(preOrderUsersNotifierProvider.notifier)
          .getPreOrderUsers(makeLoading: true);
    });
    _searchCtrl = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(preOrderUsersNotifierProvider, (previous, next) {
      ref.watch(searchNotifier.notifier).state = next.data;
    });
    final state = ref.watch(preOrderUsersNotifierProvider);
    final dataSearch = ref.watch(searchNotifier);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: _key,
        appBar: AppbarAdmin(title: "Pre Order", scaffoldKey: _key),
        endDrawer: const EndrawerWidget(),
        body: RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 1), () {
                ref
                    .read(preOrderUsersNotifierProvider.notifier)
                    .getPreOrderUsers(makeLoading: true);
              });
            },
            child: ListView(
              padding: const EdgeInsets.all(15.0),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _textfieldSearch(),
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () {
                        PanaraConfirmDialog.show(
                          context,
                          message: "Yakin reset data pre order?",
                          confirmButtonText: "Reset",
                          cancelButtonText: "Kembali",
                          onTapConfirm: () {
                            Navigator.of(context).pop();
                            ref
                                .read(resetPreOrderUsersNotifier.notifier)
                                .reset();
                          },
                          onTapCancel: Navigator.of(context).pop,
                          panaraDialogType: PanaraDialogType.error,
                        );
                      },
                      icon: const Icon(Icons.restore),
                      label: const Text("Reset"),
                    )
                  ],
                ),
                Builder(builder: (_) {
                  if (state.isLoading) {
                    return Center(
                      child: LoadingInButton(
                          color: Theme.of(context).colorScheme.primary),
                    );
                  } else if (state.error != null) {
                    return ErrorButtonWidget(
                      errorMsg: state.error!,
                      onTap: () => ref
                          .read(preOrderUsersNotifierProvider.notifier)
                          .getPreOrderUsers(),
                    );
                  }
                  return PaginatedDataTable(
                    source: MyData(dataSearch, context),
                    // header: const Text('Pesana'),
                    columns: const [
                      DataColumn(label: Text('No')),
                      DataColumn(label: Text('Waktu/Tanggal')),
                      DataColumn(label: Text('No.Pesanan')),
                      DataColumn(label: Text('Pemesan')),
                      DataColumn(label: Text('Jumlah')),
                      DataColumn(label: Text('Total Harga')),
                    ],
                    columnSpacing: 0,
                    horizontalMargin: 10,
                    rowsPerPage: 10,
                    showCheckboxColumn: false,
                  );
                }),
              ],
            )),
      ),
    );
  }

  Widget _textfieldSearch() {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.3,
      child: TextField(
          controller: _searchCtrl,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            suffixIcon: const Icon(Icons.search),
            hintText: "Silahkan Cari",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          onChanged: _handleSearch),
    );
  }

  _handleSearch(String value) {
    final resultData = ref.watch(preOrderUsersNotifierProvider).data;
    ref.watch(searchNotifier.notifier).state =
        resultData!.where((PreOrderUser item) {
      if (item.poNumber!.toLowerCase().contains(value.toLowerCase())) {
        return true;
      }
      return false;
    }).toList();
  }
}

class MyData extends DataTableSource {
  final List<PreOrderUser>? data;
  final BuildContext context;

  MyData(this.data, this.context);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data?.length ?? 0;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    return DataRow(
        selected: index % 2 == 0,
        onLongPress: () {},
        onSelectChanged: (value) {
          PanaraConfirmDialog.show(
            context,
            message: "Jadikan Pre Order sebagai Pesanan?",
            confirmButtonText: "Ya",
            cancelButtonText: "Kembali",
            onTapConfirm: () {
              Navigator.pop(context);
              nextPage(
                context,
                "${AppRoutes.admin}/pre-order-list/detail",
                argument: data![index],
              );
            },
            onTapCancel: Navigator.of(context).pop,
            panaraDialogType: PanaraDialogType.warning,
          );
        },
        cells: [
          DataCell(Text((index + 1).toString())),
          DataCell(Text(data![index].createdAt.toString().timeFormat())),
          DataCell(Text(
            "${data![index].poNumber}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          )),
          DataCell(ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: data![index].user!.image == null
                ? ProfileWithName(data![index].user!.name!)
                : CircleAvatarNetwork("$BASE/${data![index].user!.image}"),
            title: Text("${data![index].user!.name}",
                style: const TextStyle(fontSize: 16)),
          )),
          DataCell(Text("${data![index].quantity} Cup")),
          DataCell(Text("${(data![index].totalPrice!).convertToIdr()}")),
        ]);
  }
}
