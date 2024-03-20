part of "../../price_product.dart";

final selectedTypePriceProductProvider =
    StateProvider.autoDispose<String>((ref) => "Default");

class DialogFormPriceProduct extends ConsumerStatefulWidget {
  final PriceProduct? priceProductData;

  const DialogFormPriceProduct({super.key, this.priceProductData});

  @override
  ConsumerState createState() => _DialogFormPriceProductState();
}

class _DialogFormPriceProductState
    extends ConsumerState<DialogFormPriceProduct> {
  final _globalKey = GlobalKey<FormState>();
  late TextEditingController _minOrderCtrl;
  late TextEditingController _priceCtrl;

  @override
  void initState() {
    _minOrderCtrl = TextEditingController(text :"0");
    _priceCtrl = TextEditingController(text: "0");
    if (widget.priceProductData != null) {
      _minOrderCtrl.text = widget.priceProductData!.minimumOrder!;
      _priceCtrl.text = widget.priceProductData!.price!;
      Future.microtask(() {
        final type = widget.priceProductData!.priceType!.name!;
        ref.read(selectedTypePriceProductProvider.notifier).state = type;
      });
    } else {
      Future.microtask(() {
        final type = ref.watch(typePriceProductProvider);
        ref.read(selectedTypePriceProductProvider.notifier).state = type;
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _minOrderCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final type = ref.watch(selectedTypePriceProductProvider);
    return DialogWidget(
      title: widget.priceProductData == null
          ? "Tambah Harga Produk"
          : "Ubah Harga Produk",
      content: [
        Form(
          key: _globalKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownContainer(
                title: "Tipe",
                hint: "Pilih Tipe",
                value: type == "User" ? "Default" : type,
                items: typeUser
                    .map(
                      (value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  ref.read(selectedTypePriceProductProvider.notifier).state =
                      value!;
                },
              ),
              FieldInput(
                title: "Minimal order",
                controller: _minOrderCtrl,
                keyboardType: TextInputType.number,
                isRounded: false,
                suffixText: "Cup",
              ),
              FieldInput(
                title: "Harga Produk",
                controller: _priceCtrl,
                keyboardType: TextInputType.number,
                isRounded: false,
                prefixText: "Rp. ",
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    value = formatNumber(value.replaceAll('.', ''));
                    _priceCtrl.value = TextEditingValue(
                      text: value,
                      selection: TextSelection.collapsed(
                        offset: value.length,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ],
      action: [
        OutlinedButton(
          onPressed: Navigator.of(context).pop,
          child: const Text("Kembali"),
        ),
        const SizedBox(width: 10),
        FilledButton(
          onPressed: () {
            if (_globalKey.currentState!.validate()) {
              Navigator.of(context).pop();
              if (widget.priceProductData != null) {
                ref
                    .watch(updatePriceProdcutNotifier.notifier)
                    .updatePrice(
                      widget.priceProductData!.id,
                      namePriceType: type,
                      price: _priceCtrl.text.replaceAll(".", ""),
                      minimumOrder: _minOrderCtrl.text,
                    )
                    .then((success) {
                  if (!success) {
                    final msg = ref.watch(updatePriceProdcutNotifier).error;
                    showSnackbar(context, msg!, isWarning: true);
                  }
                });
              } else {
                ref
                    .watch(createPriceProdcutNotifier.notifier)
                    .createPrice(
                      namePriceType: type,
                      price: _priceCtrl.text.replaceAll(".", ""),
                      minimumOrder: _minOrderCtrl.text,
                    )
                    .then((success) {
                  if (!success) {
                    final msg = ref.watch(createPriceProdcutNotifier).error;
                    showSnackbar(context, msg!, isWarning: true);
                  }
                });
              }
            }
          },
          child: const Text("Simpan"),
        )
      ],
    );
  }
}
