part of "../order.dart";

class DetailOrderScreen extends ConsumerStatefulWidget {
  final String orderId;

  const DetailOrderScreen(this.orderId, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DetailOrderScreenState();
}

class _DetailOrderScreenState extends ConsumerState<DetailOrderScreen> {
  _getData() async {
    ref.read(orderByIdNotifier.notifier).getOrdersById(widget.orderId);
    ref.read(messageOrderNotifier.notifier).getMessage(widget.orderId);
  }

  @override
  void initState() {
    Future.microtask(() => _getData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(orderByIdNotifier);
    final order = state.data;
    final stateMessageOrder = ref.watch(messageOrderNotifier);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text("Detail Pesanan"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1), () => _getData());
        },
        child: Builder(
          builder: (_) {
            if (state.isLoading) {
              return const CircularLoading();
            } else if (state.error != null) {
              return ErrorButtonWidget(
                  errorMsg: state.error!, onTap: () => _getData());
            } else if (order == null) {
              return const EmptyWidget();
            } else {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  ///[*Detail Pengguna]
                  ExpansionTile(
                    textColor: Colors.black,
                    leading: const Icon(Icons.person),
                    title: const Text("Data Pemesan"),
                    children: [
                      ListTile(
                        title: const Text("Nama"),
                        subtitle: Text("${order.user?.name}"),
                      ),
                      ListTile(
                        title: const Text("Role Pengguna"),
                        subtitle: Text("${order.user?.role}"),
                      ),
                      ListTile(
                        title: const Text("Nomor Telepon"),
                        subtitle: Text("${order.user?.phoneNumber}"),
                      ),
                      ListTile(
                        title: const Text("Email"),
                        subtitle: Text("${order.user?.email}"),
                      ),
                    ],
                  ),

                  ///[*Detail Pesanan]
                  ExpansionTile(
                    textColor: Colors.black,
                    initiallyExpanded: true,
                    leading: const Icon(Icons.shopping_bag_outlined),
                    title: const Text("Data Pesanan"),
                    children: [
                      ListTile(
                        title: const Text("No Pesanan"),
                        subtitle: Text(
                          "${order.orderNumber}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      ListTile(
                        title: const Text("Total Pesan"),
                        subtitle: Text("${order.totalOrder} Cup"),
                        trailing: Text(
                          "Pesan : ${order.quantity} Cup \n Bonus : ${order.bonus} Cup",
                          textAlign: TextAlign.right,
                        ),
                      ),
                      ListTile(
                        title: const Text("Total Harga"),
                        subtitle: Text(order.totalPrice?.convertToIdr()),
                        trailing: Text(
                            "Cashback : ${int.parse(order.cashback!).convertToIdr()}"),
                      ),
                    ],
                  ),

                  ///[*Riwayat Transcation]
                  ExpansionTile(
                    initiallyExpanded: true,
                    textColor: Colors.black,
                    leading: const Icon(Icons.history),
                    title: const Text("Riwayat Transaksi"),
                    childrenPadding: const EdgeInsets.all(15.0),
                    children: [
                      TileOrderWIdget(
                        title: "Status pembayaran",
                        child: SizedBox(
                          width: 50,
                          child: Label(
                            status: checkStatus(order.paymentStatus),
                            title: order.paymentStatus,
                          ),
                        ),
                      ),
                      TileOrderWIdget(
                          title: "Sudah dibayar",
                          child: Text(
                              '${int.parse(order.alreadyPaid ?? "0").convertToIdr()}')),
                      TileOrderWIdget(
                        title: "Status pengambilan",
                        child: Label(
                          status: checkStatus(order.orderTakingStatus),
                          title: order.orderTakingStatus,
                        ),
                      ),
                      TileOrderWIdget(
                        title: "Sudah diambil",
                        child: Text('${order.alreadyTaken} Cup'),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => nextPage(
                            context,
                            "${AppRoutes.sa}/order/transaction",
                            argument: widget.orderId,
                          ),
                          child: const Text("Lihat detail transaksi"),
                        ),
                      )
                    ],
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class TileOrderWIdget extends StatelessWidget {
  final String title;
  final Widget child;
  const TileOrderWIdget({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(title),
          ),
          const Text(" : "),
          Expanded(flex: 2, child: child),
        ],
      ),
    );
  }
}
