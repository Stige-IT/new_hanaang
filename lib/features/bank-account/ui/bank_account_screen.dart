part of "../bank_account.dart";

class BankAccountScreen extends ConsumerStatefulWidget {
  const BankAccountScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BankAccountScreenState();
}

class _BankAccountScreenState extends ConsumerState<BankAccountScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nameBankCtrl;
  late TextEditingController _nomorBankCtrl;
  late TextEditingController _nameCtrl;
  late TextEditingController _totalCtrl;

  void _getData() {
    ref
        .watch(bankAccountNotifierProvider.notifier)
        .getBankAccounts(makeLoading: true);
  }

  @override
  void initState() {
    Future.microtask(() => _getData());
    _nameBankCtrl = TextEditingController();
    _nomorBankCtrl = TextEditingController();
    _nameCtrl = TextEditingController();
    _totalCtrl = TextEditingController(text: "0");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final BankAccountState state = ref.watch(bankAccountNotifierProvider);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              title: const Text("Daftar Bank"),
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(
                    const Duration(seconds: 1), () => _getData());
              },
              child: Builder(
                builder: (_) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.error != null) {
                    return Center(
                      child: ErrorButtonWidget(
                        errorMsg: state.error!,
                        onTap: _getData,
                      ),
                    );
                  } else {
                    return GridView.count(
                      padding: const EdgeInsets.all(10),
                      crossAxisCount: 2,
                      children: (state.data ?? [])
                          .map((account) => CardBank(account: account))
                          .toList(),
                    );
                  }
                },
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Theme.of(context).colorScheme.primary,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => const DialogFormBankAccount(),
                );
              },
              child: const Icon(Icons.add),
            ),
          ),
          if (ref.watch(createBankAccountNotifier).isLoading)
            const DialogLoading()
        ],
      ),
    );
  }
}
