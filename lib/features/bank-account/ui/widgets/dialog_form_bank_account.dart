part of "../../bank_account.dart";

class DialogFormBankAccount extends ConsumerStatefulWidget {
  const DialogFormBankAccount({super.key});

  @override
  ConsumerState createState() => _DialogFormBankAccountState();
}

class _DialogFormBankAccountState extends ConsumerState<DialogFormBankAccount> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nameBankCtrl;
  late TextEditingController _nomorBankCtrl;
  late TextEditingController _nameCtrl;
  late TextEditingController _totalCtrl;

  @override
  void initState() {
    _nameBankCtrl = TextEditingController();
    _nomorBankCtrl = TextEditingController();
    _nameCtrl = TextEditingController();
    _totalCtrl = TextEditingController(text: "0");
    super.initState();
  }

  @override
  void dispose() {
    _nameBankCtrl.dispose();
    _nomorBankCtrl.dispose();
    _nameCtrl.dispose();
    _totalCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DialogWidget(
      title: "Tambah Akun Bank",
      content: [
        Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FieldInput(
                title: "Nama Bank",
                hintText: "Masukkan Nama Bank",
                controller: _nameBankCtrl,
              ),
              FieldInput(
                title: "No.Rekening",
                hintText: "Masukkan No.Rekening",
                controller: _nomorBankCtrl,
                keyboardType: TextInputType.number,
              ),
              FieldInput(
                title: "Nama Lengkap",
                hintText: "Masukkan Nama",
                controller: _nameCtrl,
              ),
              FieldInput(
                prefixText: "Rp. ",
                title: "Saldo Bank",
                hintText: "Masukkan total saldo",
                controller: _totalCtrl,
                keyboardType: TextInputType.number,
                onTap: () {
                  if (_totalCtrl.text.length <= 1) {
                    _totalCtrl.clear();
                  }
                },
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    value = formatNumber(value.replaceAll('.', ''));
                    _totalCtrl.value = TextEditingValue(
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
            if (_formKey.currentState!.validate()) {
              Navigator.of(context).pop();
              ref
                  .watch(createBankAccountNotifier.notifier)
                  .createBankAccount(
                    bankName: _nameBankCtrl.text,
                    accountName: _nameCtrl.text,
                    accountNumber: _nomorBankCtrl.text,
                    ballance: _totalCtrl.text.replaceAll(".", ""),
                  )
                  .then(
                (succcess) {
                  if (succcess) {
                    showSnackbar(context, "Berhasil membuat akun bank baru");
                  } else {
                    showSnackbar(
                      context,
                      ref.watch(createBankAccountNotifier).error!,
                      isWarning: true,
                    );
                  }
                },
              );
            }
          },
          child: const Text("Simpan"),
        ),
      ],
    );
  }
}
