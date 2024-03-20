part of '../pre_order.dart';

final isBonusProvider = StateProvider.autoDispose<bool>((ref) => false);

class FormPreOrderScreen extends ConsumerStatefulWidget {
  final PreOrderUser dataUser;

  const FormPreOrderScreen(this.dataUser, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FormPreOrderScreenState();
}

class _FormPreOrderScreenState extends ConsumerState<FormPreOrderScreen> {
  File? image;
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TextEditingController _quantityOrderCtrl;
  late TextEditingController _nominalCtrl;
  late DraggableScrollableController _draggableScrollableController;

  @override
  void initState() {
    Future.microtask(() {
      ref.watch(quantityNotifier.notifier).state = widget.dataUser.quantity!;
    });
    final quantity = widget.dataUser.quantity!.toString();
    _quantityOrderCtrl = TextEditingController(text: quantity);
    _nominalCtrl = TextEditingController(text: "0");
    _draggableScrollableController = DraggableScrollableController();
    super.initState();
  }

  @override
  void dispose() {
    _quantityOrderCtrl.dispose();
    _nominalCtrl.dispose();
    _draggableScrollableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool toogleIsEnable = ref.watch(togglePaidProvider);
    final methodPaidKey = ref.watch(dropdownMethodPainNotifier);
    Map items = {
      "Cash": "e103202b-f615-46ba-9e66-7efe8bc568b6",
      "Transfer": "a9e653ea-3a35-4473-9bb2-1fab7e67c970",
    };

    ref.listen(checkBonusNotifierProvider, (previous, next) {
      if (next > 0) {
        showSnackbar(context, "Berhasil mendapatkan bonus");
      }
    });

    ref.listen(checkCashbackNotifierProvider, (previous, next) {
      final cashback = next.data ?? 0;
      if ( cashback > 0) {
        showSnackbar(context, "Berhasil mendapatkan Cashback ${cashback.convertToIdr()}");
      }
    });

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        appBar: AppBar(
            elevation: 0, centerTitle: true, title: const Text("Form Pesanan")),
        body: Stack(
          children: [
            Form(
              key: _globalKey,
              child: ListView(
                padding: const EdgeInsets.all(15),
                children: [
                  ///[*Input quantity take order]
                  QuantityWidget(
                    data: widget.dataUser,
                    controller: _quantityOrderCtrl,
                  ),

                  ///[*Toggle Switch payment]
                  _toggleIsPayment(toogleIsEnable),
                  const Text(
                    "* Jika melakukan pembayaran sekarang maka akan terhitung bonus",
                    style: TextStyle(
                      color: Colors.black26,
                      fontSize: 10,
                    ),
                  ),

                  ///[*From payment when toggle is active]
                  _formPayment(toogleIsEnable, methodPaidKey, items),
                  const SizedBox(height: 200),
                ],
              ),
            ),
            DragabbleWidget(
              _draggableScrollableController,
              data: widget.dataUser,
              nominalCtrl: _nominalCtrl,
              globalKey: _globalKey,
            ),
            if(ref.watch(checkCashbackNotifierProvider).isLoading)
              const DialogLoading()
          ],
        ),
      ),
    );
  }

  Row _toggleIsPayment(bool toogleIsEnable) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            if (toogleIsEnable) {
              ref.invalidate(checkBonusNotifierProvider);
              ref.invalidate(checkCashbackNotifierProvider);
              ref.invalidate(isBonusProvider);
              _nominalCtrl.text = "0";
            } else {
              ref.read(checkCashbackNotifierProvider.notifier).checkCashback(
                    widget.dataUser.user!.id!,
                    widget.dataUser.quantity!,
                  );
            }
            ref.watch(togglePaidProvider.notifier).state = !toogleIsEnable;
          },
          icon: Icon(
            toogleIsEnable ? Icons.toggle_on : Icons.toggle_off_outlined,
            size: 40,
            color: toogleIsEnable ? Theme.of(context).colorScheme.primary : Colors.grey,
          ),
        ),
        const Text("Lakukan Pembayaran"),
      ],
    );
  }

  Visibility _formPayment(
      bool toogleIsEnable, String? methodPaidKey, Map<dynamic, dynamic> items) {
    return Visibility(
      visible: toogleIsEnable,
      child: Column(
        children: [
          const SizedBox(height: 10),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              "Metode Pembayaran",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            subtitle: Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                      offset: Offset(2, 2),
                      blurRadius: 2,
                      color: Colors.black12),
                ],
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  dropdownColor: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(15),
                  isExpanded: true,
                  hint: const Text("Pilih Metode Pembayaran"),
                  value: methodPaidKey,
                  items: items
                      .map((key, value) => MapEntry(
                            key,
                            DropdownMenuItem(
                              value: value,
                              child: Text(key),
                            ),
                          ))
                      .values
                      .toList(),
                  onChanged: (value) {
                    ref.watch(dropdownMethodPainNotifier.notifier).state =
                        (value.toString());
                  },
                ),
              ),
            ),
          ),
          FieldInput(
            prefixText: "RP. ",
            title: "Nominal",
            hintText: "0",
            controller: _nominalCtrl,
            textValidator: "",
            keyboardType: TextInputType.number,
            obsecureText: false,
            onTap: () {},
            onEditingComplete: () {
              if (_nominalCtrl.text.isEmpty) {
                _nominalCtrl.text = '0';
              }
              FocusScope.of(context).unfocus();
            },
            onChanged: (value) {
              if (value.isNotEmpty) {
                value = formatNumber(value.replaceAll('.', ''));
                _nominalCtrl.value = TextEditingValue(
                  text: value,
                  selection: TextSelection.collapsed(offset: value.length),
                );
                final nominal = int.parse(value.replaceAll(".", ''));
                if (nominal >= widget.dataUser.totalPrice!) {
                  ref.read(checkBonusNotifierProvider.notifier).checkBonus(
                        widget.dataUser.user!.id!,
                        int.parse(_quantityOrderCtrl.text),
                      );
                } else {
                  ref.invalidate(checkBonusNotifierProvider);
                }
              } else {
                _nominalCtrl.text = "0";
              }
            },
          ),
          const SizedBox(height: 5),
          ListTile(
            title: const Text(
              "Bukti Pembayaran",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            subtitle: image == null
                ? OutlinedButton.icon(
                    onPressed: () async => await _handleGetImage(),
                    label: const Text("Tambahkan gambar"),
                    icon: const Icon(Icons.add),
                  )
                : InkWell(
                    onTap: () async => await _handleGetImage(),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: SizedBox(
                        height: 100,
                        width: double.infinity,
                        child: Image.file(
                          image!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
          )
        ],
      ),
    );
  }

  _handleGetImage() async {
    File? newImage;
    await showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        )),
        context: context,
        builder: (_) {
          return ModalBottomOptionImagePicker(
            onTapCamera: () async {
              newImage = await ref
                  .watch(imagePickerProvider.notifier)
                  .getFromGallery(source: ImageSource.camera);
              if (!mounted) return;
              Navigator.pop(context);
            },
            onTapGalery: () async {
              newImage = await ref
                  .watch(imagePickerProvider.notifier)
                  .getFromGallery(source: ImageSource.gallery);
              if (!mounted) return;
              Navigator.pop(context);
            },
          );
        });
    if (newImage != null) {
      setState(() {
        image = newImage;
      });
    }
  }
}
