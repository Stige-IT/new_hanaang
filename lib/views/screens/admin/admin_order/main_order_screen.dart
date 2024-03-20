import 'package:admin_hanaang/config/router/router_config.dart';
import 'package:admin_hanaang/features/stock/provider/stock_provider.dart';
import 'package:admin_hanaang/features/user/provider/user_provider.dart';
import 'package:admin_hanaang/utils/extensions/currency_format.dart';
import 'package:admin_hanaang/utils/extensions/date_formater.dart';
import 'package:admin_hanaang/views/components/label.dart';
import 'package:admin_hanaang/views/components/loading_in_button.dart';
import 'package:admin_hanaang/views/screens/admin/components/gridview_product_stock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/constant/status.dart';
import '../../../../features/order/order.dart';
import '../../../../utils/helper/checkStatusLabel.dart';
import '../../../components/navigation_widget.dart';
import '../../../components/appbar_admin.dart';
import '../components/endrawer/endrawer_widget.dart';

class OrderScreenAdmin extends ConsumerStatefulWidget {
  const OrderScreenAdmin({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MainOrderScreenState();
}

class _MainOrderScreenState extends ConsumerState<OrderScreenAdmin> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TextEditingController _searchCtrl;

  _getStock() {
    ref.read(totalStockNotifier.notifier).getStock();
    ref.read(soldStockNotifier.notifier).getStock();
    ref.read(remainingStockNotifier.notifier).getStock();
    ref.read(returStockNotifier.notifier).getStock();
  }

  @override
  void initState() {
    Future.microtask(() async {
      ref.watch(orderNotifier.notifier).getOrders(makeLoading: true);
      ref.watch(userNotifierProvider.notifier).getProfile();
    });
    _searchCtrl = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    ref.invalidate(paymentStatusProvider);
    ref.invalidate(takeOrderStatusProvider);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(orderNotifier);
    final data = state.data;
    final paymentStatusvalue = ref.watch(paymentStatusProvider);
    final takeOrderStatusValue = ref.watch(takeOrderStatusProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      endDrawer: const EndrawerWidget(),
      appBar: AppbarAdmin(isMain: true, scaffoldKey: _scaffoldKey),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => nextPage(context, "${AppRoutes.admin}/order/form"),
        label: const Text("Tambah Pesanan"),
        icon: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1), () {
            ref.watch(orderNotifier.notifier).refresh();
            ref.watch(userNotifierProvider.notifier).getProfile();
            _getStock();
          });
        },
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ///[* Button type Order paid]
                    _dropdownFilter(paymentStatusvalue, takeOrderStatusValue),
                    const SizedBox(width: 20),
                    FilledButton.icon(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                title: const Text("Info Produk"),
                                content: const GridviewProductStock(),
                                actions: [
                                  OutlinedButton(
                                      onPressed: Navigator.of(context).pop,
                                      child: const Text(
                                        "Kembali",
                                      )),
                                ],
                              );
                            });
                      },
                      icon: const Icon(Icons.info_outline),
                      label: const Text("info Produk"),
                    ),
                    // const Spacer(),
                    const SizedBox(width: 50),
                    if (state.isLoading)
                      LoadingInButton(color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 50),
                    IconButton(
                        onPressed: () {
                          ref.watch(orderNotifier.notifier).refresh();
                          _getStock();
                        },
                        icon: const Icon(Icons.refresh)),
                    _textfieldSearch(),
                  ],
                ),
                Expanded(
                  flex: 2,
                  child: Card(
                    elevation: 5,
                    child: ListView.builder(
                        padding: const EdgeInsets.all(15.0),
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return DataTable(
                              columnSpacing: 0,
                              border: TableBorder(
                                  horizontalInside: const BorderSide(
                                    width: 1,
                                    color: Colors.black38,
                                  ),
                                  borderRadius: BorderRadius.circular(15)),
                              showBottomBorder: true,
                              showCheckboxColumn: false,
                              headingTextStyle: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              columns: const [
                                DataColumn(
                                    label: Expanded(
                                        child: Center(child: Text('No')))),
                                DataColumn(
                                    label: Expanded(
                                        child: Center(
                                            child: Text('Waktu/Tanggal')))),
                                DataColumn(
                                    label: Expanded(
                                        child:
                                            Center(child: Text('No.Pesanan')))),
                                DataColumn(
                                    label: Expanded(
                                        child: Center(child: Text('Jumlah')))),
                                // DataColumn(
                                //     label: Expanded(
                                //         child: Center(child: Text('Harga')))),
                                DataColumn(
                                    label: Expanded(
                                        child: Center(
                                            child: Text('Total Harga')))),
                                DataColumn(
                                    label: Expanded(
                                        child: Center(
                                            child: Text('Status',
                                                textAlign: TextAlign.center)))),
                              ],
                              rows: List.generate((data ?? []).length, (index) {
                                final order = data?[index];
                                final paymentStatus = order!.paymentStatus;
                                final takingOrderStatus =
                                    order.orderTakingStatus;
                                return DataRow(
                                  selected: index % 2 == 0,
                                  onSelectChanged: (value) {
                                    nextPage(
                                      context,
                                      "${AppRoutes.admin}/order/detail",
                                      argument: order,
                                    );
                                  },
                                  cells: [
                                    DataCell(Center(
                                        child: Text((index + 1).toString()))),
                                    DataCell(Center(
                                      child: Text(
                                        order.createdAt.toString().timeFormat(),
                                      ),
                                    )),
                                    DataCell(Center(
                                      child: Text(
                                        "${order.orderNumber}",
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 2),
                                      ),
                                    )),
                                    DataCell(Center(
                                        child:
                                            Text("${order.totalOrder} Cup"))),
                                    // DataCell(Expanded(
                                    //   child: Center(
                                    //     child: Text(
                                    //         "${int.parse(order.totalPrice!).convertToIdr()}"),
                                    //   ),
                                    // )),
                                    DataCell(Center(
                                      child: Text(
                                        order.totalPrice?.convertToIdr(),
                                      ),
                                    )),
                                    DataCell(Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 23,
                                          child: Label(
                                            title: checkNamed(paymentStatus!),
                                            status: checkStatus(paymentStatus),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 23,
                                          child: Label(
                                            title:
                                                checkNamed(takingOrderStatus!),
                                            status:
                                                checkStatus(takingOrderStatus),
                                          ),
                                        ),
                                      ],
                                    )),
                                  ],
                                );
                              }));
                        }),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        ref.watch(orderNotifier).page > 1
                            ? ref.watch(orderNotifier.notifier).prevOrders()
                            : null;
                      },
                    ),
                    Text(
                        'Page ${ref.watch(orderNotifier).page} of ${ref.watch(orderNotifier).lastPage}'),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () {
                        ref.watch(orderNotifier).page <
                                ref.watch(orderNotifier).lastPage
                            ? ref.watch(orderNotifier.notifier).nextOrders(
                                  isDataTable: true,
                                  makeLoading: true,
                                )
                            : null;
                      },
                    ),
                  ],
                ),
                // const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Expanded _textfieldSearch() {
    return Expanded(
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
        onChanged: (value) {
          if (value.isNotEmpty) {
            ref.invalidate(paymentStatusProvider);
            ref.invalidate(takeOrderStatusProvider);
            ref.watch(orderNotifier.notifier).searchOrders(query: value);
          }
        },
      ),
    );
  }

  Row _dropdownFilter(
      String? paymentStatusvalue, String? takeOrderStatusValue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                  dropdownColor: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(10),
                  value: paymentStatusvalue,
                  hint: const Text(
                    "Pilih Status Bayar",
                    style: TextStyle(fontSize: 14),
                  ),
                  items: statusPayment
                      .map(
                        (key, value) => MapEntry(
                          key,
                          DropdownMenuItem<String>(
                            value: value,
                            child: Text(key),
                          ),
                        ),
                      )
                      .values
                      .toList(),
                  onChanged: (value) {
                    ref.watch(paymentStatusProvider.notifier).state = value!;
                    ref
                        .watch(orderNotifier.notifier)
                        .getOrders(page: ref.watch(orderNotifier).page);
                  }),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                dropdownColor: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(10),
                value: takeOrderStatusValue,
                hint: const Text(
                  "Pilih Status ambil",
                  style: TextStyle(fontSize: 14),
                ),
                items: statusTakeOrder
                    .map(
                      (key, value) => MapEntry(
                        key,
                        DropdownMenuItem<String>(
                          value: value,
                          child: Text(key),
                        ),
                      ),
                    )
                    .values
                    .toList(),
                onChanged: (value) {
                  ref.watch(takeOrderStatusProvider.notifier).state = value!;
                  ref
                      .watch(orderNotifier.notifier)
                      .getOrders(page: ref.watch(orderNotifier).page);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
