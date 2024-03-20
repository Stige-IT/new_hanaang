part of "../pre_order.dart";

class DragabbleWidget extends ConsumerStatefulWidget {
  final DraggableScrollableController controller;
  final PreOrderUser data;
  final TextEditingController nominalCtrl;
  final GlobalKey<FormState> globalKey;
  final File? image;

  const DragabbleWidget(
    this.controller, {
    super.key,
    required this.data,
    required this.nominalCtrl,
    required this.globalKey,
    this.image,
  });

  @override
  ConsumerState createState() => _DragabbleWidgetState();
}

class _DragabbleWidgetState extends ConsumerState<DragabbleWidget> {
  @override
  Widget build(BuildContext context) {
    final int quantity = ref.watch(quantityNotifier);
    final int totalBonus = ref.watch(checkBonusNotifierProvider);
    final int cashback = ref.watch(checkCashbackNotifierProvider).data ?? 0;

    return DraggableScrollableSheet(
        controller: widget.controller,
        snap: true,
        shouldCloseOnMinExtent: true,
        initialChildSize: 0.3,
        minChildSize: 0.3,
        maxChildSize: 0.7,
        builder: (_, scrollController) {
          return ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 20),
              controller: scrollController,
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                      boxShadow: const [
                        BoxShadow(
                            offset: Offset(0, -5),
                            blurRadius: 5,
                            color: Colors.black12)
                      ]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Center(
                        child:
                            SizedBox(width: 50, child: Divider(thickness: 3)),
                      ),
                      bottomSheetWidget(quantity, totalBonus, cashback)
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget bottomSheetWidget(int quantity, totalBonus, cashback) {
    final methodId = ref.watch(dropdownMethodPainNotifier);
    final isLoading = ref.watch(updatePreOrderUsersNotifier).isLoading;
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          TileResult(
            isHeading: true,
            title: "total Bayar",
            value: widget.data.totalPrice!.convertToIdr(),
          ),
          TileResult(
            isHeading: true,
            title: "Bayar",
            value: int.parse(widget.nominalCtrl.text.isEmpty
                    ? "0"
                    : widget.nominalCtrl.text.replaceAll('.', ''))
                .convertToIdr(),
          ),
          TileResult(
            isHeading: true,
            title: isMoreThanTotalPrice() ? "Kembalian" : "Sisa",
            value: "Rp ${resultPrice()}",
          ),
          const Divider(thickness: 2),
          TileResult(
            title: "Jumlah Pengambilan",
            value: "$quantity Cup",
          ),
          TileResult(
            title: "Bonus",
            value: "$totalBonus Cup",
          ),
          TileResult(
            title: "Cashback",
            value: int.parse(cashback.toString()).convertToIdr(),
          ),
          TileResult(
            title: "Harga satuan",
            value: "${(widget.data.price!).convertToIdr()}/Cup",
          ),
          TileResult(
            title: "total Pesanan",
            value: "${widget.data.quantity!} Cup",
          ),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: () async {
                if (!isLoading) {
                  if (widget.globalKey.currentState!.validate()) {
                    int nominal =
                        int.parse(widget.nominalCtrl.text.replaceAll(".", ""));
                    if (isMoreThanTotalPrice()) {
                      nominal = widget.data.totalPrice!.abs();
                    }
                    ref
                        .read(updatePreOrderUsersNotifier.notifier)
                        .updateToOrder(
                          widget.data.id!,
                          widget.data.user!.id!,
                          orderTaken: quantity,
                          nominal: nominal,
                          proofOfPayment: widget.image,
                          paymentMethodId: methodId,
                        )
                        .then((success) {
                      if (success) {
                        Navigator.of(context).pop();
                        showSnackbar(context, 'Berhasil menjadikan pesanan');
                      } else {
                        if (!mounted) return;
                        showSnackbar(context, 'Gagal menjadikan pesanan',
                            isWarning: true);
                      }
                    });
                  } else {
                    widget.controller.reset();
                  }
                }
              },
              child: ref.watch(updatePreOrderUsersNotifier).isLoading
                  ? const LoadingInButton()
                  : const Text("Simpan"))
        ],
      ),
    );
  }

  String resultPrice(){
    final nominal = int.parse(widget.nominalCtrl.text.replaceAll('.', ''));
    String total = ((widget.data.totalPrice! - nominal).abs()).toString();
    return formatNumber(total);
  }

  bool isMoreThanTotalPrice() {
    if (widget.nominalCtrl.text.isNotEmpty) {
      final nominal = int.parse(widget.nominalCtrl.text.replaceAll(".", ""));
      if (nominal >= widget.data.totalPrice!) {
        return true;
      }
    }
    return false;
  }
}
