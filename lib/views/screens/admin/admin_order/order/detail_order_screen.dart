import 'package:admin_hanaang/config/router/router_config.dart';
import 'package:admin_hanaang/models/order.dart';
import 'package:admin_hanaang/utils/extensions/currency_format.dart';
import 'package:admin_hanaang/views/components/label.dart';
import 'package:admin_hanaang/views/components/navigation_widget.dart';
import 'package:admin_hanaang/views/screens/admin/components/endrawer/endrawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../features/order/order.dart';
import '../../../../../features/user/provider/user_provider.dart';
import '../../../../../utils/helper/check_label_with_id.dart';
import '../../../../components/appbar_admin.dart';

class DetailOrderScreenAdmin extends ConsumerStatefulWidget {
  final OrderData dataOrder;

  const DetailOrderScreenAdmin(this.dataOrder, {super.key});

  @override
  ConsumerState createState() => _DetailOrderScreenAOState();
}

class _DetailOrderScreenAOState extends ConsumerState<DetailOrderScreenAdmin> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
      ref.watch(orderByIdNotifier.notifier).getOrdersById(widget.dataOrder.id!);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(orderByIdNotifier);
    final order = state.data;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppbarAdmin(
        scaffoldKey: _scaffoldKey,
        title: "Detail Pesanan",
      ),
      endDrawer: const EndrawerWidget(),
      body: state.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : order == null
              ? const Center(
                  child: Text("Data Tidak ditemukan"),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    await Future.delayed(const Duration(seconds: 1), () {
                      ref.watch(userNotifierProvider.notifier).getProfile();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: GridView.count(
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      crossAxisCount: 2,
                      childAspectRatio: 1.8 / 1,
                      children: [
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              const ListTile(
                                leading: Icon(Icons.person, color: Colors.blue),
                                title: Text(
                                  "Data Pemesan",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                visualDensity: VisualDensity(vertical: -4),
                              ),
                              TileDetail(
                                  title: "Nama Pemesan:",
                                  value: order.user?.name),
                              TileDetail(
                                  title: "Role :", value: order.user?.role),
                              TileDetail(
                                  title: "Email :", value: order.user?.email),
                              TileDetail(
                                  title: "No.Telepon :",
                                  value: order.user?.phoneNumber),
                            ],
                          ),
                        ),
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                leading: Icon(
                                  Icons.local_drink_rounded,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                title: const Text(
                                  "Pesanan",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                visualDensity: const VisualDensity(vertical: -4),
                              ),
                              TileDetail(
                                title: "Nomor Pesanan :",
                                value: "${order.orderNumber}",
                                isBold: true,
                              ),
                              TileDetail(
                                  title: "Total Pesanan :",
                                  value: "${order.totalOrder} Cup"),
                              TileDetail(
                                title: "Bonus :",
                                value: "${order.bonus} Cup",
                              ),
                              TileDetail(
                                title: "Total Harga :",
                                value: order.totalPrice?.convertToIdr(),
                              ),
                              TileDetail(
                                title: "Cashback :",
                                value:
                                    int.parse(order.cashback!).convertToIdr(),
                              ),
                            ],
                          ),
                        ),
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                visualDensity:
                                    const VisualDensity(vertical: -4),
                                leading: const Icon(
                                  Icons.money,
                                  color: Colors.green,
                                ),
                                title: const Text(
                                  "Riwayat Pembayaran",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                trailing: TextButton(
                                    onPressed: () {
                                      nextPage(context,
                                          "${AppRoutes.admin}/order/history",
                                          argument: [true, order]);
                                    },
                                    child: const Text("Detail Pembayaran ->")),
                              ),
                              TileDetail(
                                title: "Status Pembayaran :",
                                child: SizedBox(
                                  width: 100,
                                  height: 30,
                                  child: Label(
                                    status: checkStatus(
                                        order.orderPayment!.paymentStatus!),
                                    title: order.orderPayment!.paymentStatus,
                                  ),
                                ),
                              ),
                              TileDetail(
                                title: "Bayar :",
                                value:
                                    '${int.parse(order.orderPayment!.alreadyPaid!).convertToIdr()}',
                              ),
                              TileDetail(
                                title: "Sisa :",
                                value:
                                    '${int.parse(order.orderPayment!.notYetPaid!).convertToIdr()}',
                              ),
                            ],
                          ),
                        ),
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                visualDensity:
                                    const VisualDensity(vertical: -4),
                                leading: const Icon(
                                  Icons.shopping_bag_outlined,
                                  color: Colors.purple,
                                ),
                                title: const Text(
                                  "Riwayat Pengambilan",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                trailing: TextButton(
                                    onPressed: () {
                                      nextPage(context,
                                          "${AppRoutes.admin}/order/history",
                                          argument: [false, order]);
                                    },
                                    child: const Text("Detail Pengambilan ->")),
                              ),
                              TileDetail(
                                title: "Status Pengambilan :",
                                child: SizedBox(
                                  width: 100,
                                  height: 30,
                                  child: Label(
                                    status: checkStatus(
                                        order.orderTaking!.orderTakingStatus!),
                                    title: order.orderTaking!.orderTakingStatus,
                                  ),
                                ),
                              ),
                              TileDetail(
                                title: "Diambil :",
                                value: '${order.orderTaking!.alreadyTaken} Cup',
                              ),
                              TileDetail(
                                title: "Sisa :",
                                value: '${order.orderTaking!.notYetTaken} Cup',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}

class TileDetail extends StatelessWidget {
  final String? title;
  final String? value;
  final Widget? child;
  final bool? isBold;

  const TileDetail({
    super.key,
    this.title,
    this.value,
    this.child,
    this.isBold,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12))),
      child: ListTile(
        visualDensity: const VisualDensity(vertical: -4),
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
        title: Text(
          title ?? "-",
          style: const TextStyle(fontSize: 14),
        ),
        trailing: child ??
            Text(
              value ?? "-",
              style: TextStyle(
                fontWeight: isBold != null && isBold!
                    ? FontWeight.bold
                    : FontWeight.w600,
                fontSize: isBold != null && isBold! ? 20 : 14,
              ),
            ),
      ),
    );
  }
}
