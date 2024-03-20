part of "../../bonus.dart";

final selectedTypeProvider =
    StateProvider.autoDispose<String>((ref) => "Default");

class DialogFormBonus extends ConsumerStatefulWidget {
  final Bonus? bonusData;

  const DialogFormBonus({super.key, this.bonusData});

  @override
  ConsumerState createState() => _DialogFormBonusState();
}

class _DialogFormBonusState extends ConsumerState<DialogFormBonus> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  late TextEditingController _minOrderCtrl;
  late TextEditingController _jumlahBonusCtrl;

  @override
  void initState() {
    _minOrderCtrl = TextEditingController(text: "");
    _jumlahBonusCtrl = TextEditingController(text: "");
    if (widget.bonusData != null) {
      _minOrderCtrl.text = widget.bonusData!.minimumOrder.toString();
      _jumlahBonusCtrl.text = widget.bonusData!.numberOfBonus.toString();
      Future.microtask(() {
        final type = widget.bonusData!.bonusType!.name!;
        ref.read(selectedTypeProvider.notifier).state =
            type == "User" ? "Default" : type;
      });
    } else {
      Future.microtask(() {
        final type = ref.watch(typeIdBonusProvider);
        ref.read(selectedTypeProvider.notifier).state = type;
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _minOrderCtrl.dispose();
    _jumlahBonusCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selected = ref.watch(selectedTypeProvider);
    return DialogWidget(
      title: widget.bonusData == null ? "Tambah Bonus" : "Edit Bonus",
      content: [
        Form(
          key: _globalKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownContainer(
                title: "Tipe Bonus Pengguna",
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
                  ref.read(selectedTypeProvider.notifier).state = value!;
                },
              ),
              FieldInput(
                title: "Minimal Order",
                hintText: "Masukkan minimal Order",
                controller: _minOrderCtrl,
                keyboardType: TextInputType.number,
                suffixText: " Cup",
                isRounded: false,
              ),
              FieldInput(
                title: "Jumlah Bonus",
                hintText: "Masukkan minimal Order",
                controller: _jumlahBonusCtrl,
                keyboardType: TextInputType.number,
                suffixText: " Cup",
                isRounded: false,
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
              if (widget.bonusData != null) {
                ref
                    .watch(updateBonusNotifier.notifier)
                    .updateBonus(
                      widget.bonusData!.id!,
                      bonusType: selected,
                      minimumOrder: _minOrderCtrl.text,
                      numberOfBonus: _jumlahBonusCtrl.text,
                    )
                    .then((success) {
                  if (!success) {
                    final msgError = ref.watch(createBonusNotifier).error;
                    showSnackbar(context, msgError!, isWarning: true);
                  }
                });
              }

              ///[CREATE NEW BONUS DATA]
              else {
                ref
                    .watch(createBonusNotifier.notifier)
                    .createBonus(
                      bonusType: selected,
                      minimumOrder: _minOrderCtrl.text,
                      numberOfBonus: _jumlahBonusCtrl.text,
                    )
                    .then((success) {
                  if (!success) {
                    final msgError = ref.watch(createBonusNotifier).error;
                    showSnackbar(context, msgError!, isWarning: true);
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
