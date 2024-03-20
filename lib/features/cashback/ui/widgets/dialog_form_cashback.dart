part of "../../cashback.dart";

final selectedTypeCashbackProvider =
    StateProvider.autoDispose<String>((ref) => "Default");

class DialogFormCashback extends ConsumerStatefulWidget {
  final Cashback? cashbackData;

  const DialogFormCashback({super.key, this.cashbackData});

  @override
  ConsumerState createState() => _DialogFormCashbackState();
}

class _DialogFormCashbackState extends ConsumerState<DialogFormCashback> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  late TextEditingController _minOrderCtrl;
  late TextEditingController _jumlahCashbck;

  @override
  void initState() {
    _minOrderCtrl = TextEditingController();
    _jumlahCashbck = TextEditingController(text: "0");
    super.initState();
  }

  @override
  void dispose() {
    _minOrderCtrl.dispose();
    _jumlahCashbck.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selected = ref.watch(selectedTypeCashbackProvider);
    return DialogWidget(
      title: widget.cashbackData == null ? "Tambah Cashback" : "Edit Cashback",
      content: [
        Form(
          key: _globalKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownContainer(
                title: "Tipe",
                hint: "Pilih Tipe",
                value: selected,
                items: typeUser
                    .map(
                      (value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  ref.read(selectedTypeCashbackProvider.notifier).state =
                      value!;
                },
              ),
              FieldInput(
                title: "Minimal Order",
                controller: _minOrderCtrl,
                suffixText: "Cup",
                keyboardType: TextInputType.number,
                isRounded: false,
              ),
              FieldInput(
                title: "Jumlah Cashback",
                controller: _jumlahCashbck,
                keyboardType: TextInputType.number,
                prefixText: "Rp. ",
                isRounded: false,
                onTap: () {
                  if (_jumlahCashbck.text.length <= 1) {
                    _jumlahCashbck.clear();
                  }
                },
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    value = formatNumber(value.replaceAll('.', ''));
                    _jumlahCashbck.value = TextEditingValue(
                      text: value,
                      selection: TextSelection.collapsed(offset: value.length),
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
        ElevatedButton(
          onPressed: () {
            if (_globalKey.currentState!.validate()) {
              Navigator.of(context).pop();

              ///[EDIT DATA BONUS PER ID]
              if (widget.cashbackData != null) {
                ref
                    .watch(updateCashbackNotifier.notifier)
                    .updateCashback(
                      widget.cashbackData!.id!,
                      cashbackType: selected,
                      minimumOrder: _minOrderCtrl.text,
                      cashbackOfNumber: _jumlahCashbck.text.replaceAll('.', ''),
                    )
                    .then((success) {
                  if (!success) {
                    final msg = ref.watch(updateCashbackNotifier).error;
                    showSnackbar(context, msg!, isWarning: true);
                  }
                });
              }

              ///[CREATE NEW BONUS DATA]
              else {
                ref
                    .watch(createCashbackNotifier.notifier)
                    .createCashback(
                      cashbackType: selected,
                      minimumOrder: _minOrderCtrl.text,
                      cashbackOfNumber: _jumlahCashbck.text.replaceAll('.', ''),
                    )
                    .then((success) {
                  if (!success) {
                    final msg = ref.watch(createCashbackNotifier).error;
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
