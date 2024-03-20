part of"pre_order.dart";

class PreOrderUsersScreen extends ConsumerStatefulWidget {
  const PreOrderUsersScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PreOrderUsersScreenState();
}

class _PreOrderUsersScreenState extends ConsumerState<PreOrderUsersScreen> {
  late TextEditingController _searchCtrl;

  void _getData() =>
      ref.read(preOrderUsersNotifierProvider.notifier).getPreOrderUsers();

  @override
  void initState() {
    _searchCtrl = TextEditingController();
    Future.microtask(() => _getData());
    super.initState();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(preOrderUsersNotifierProvider);
    bool isShowSearch = ref.watch(isShowProvider);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: isShowSearch
            ? _buildSearchAppbar()
            : const Text("Daftar Pre Order"),
        actions: [
          IconButton(
            onPressed: () {
              if (isShowSearch) {
                _searchCtrl.clear();
              }
              ref.watch(isShowProvider.notifier).state = !isShowSearch;
            },
            icon: isShowSearch
                ? const Icon(Icons.close)
                : const Icon(Icons.search),
          ),
        ],
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(
                  const Duration(seconds: 1), () => _getData());
            },
            child: Builder(builder: (_) {
              if (state.isLoading) {
                return const CircularLoading();
              } else if (state.error != null) {
                return FailureWidget(
                  error: state.error!,
                  onPressed: () => _getData(),
                );
              } else if (state.data == null || state.data!.isEmpty) {
                return const EmptyWidget();
              } else {
                return Column(
                  children: [
                    if (state.data!.isNotEmpty)
                      ListTile(
                        title: const Text("Reset data pre-order ?"),
                        trailing: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: _handleReset,
                          child: const Text("Reset"),
                        ),
                      ),
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(10.0),
                        itemCount: state.data!.length,
                        itemBuilder: (_, i) {
                          PreOrderUser data = state.data![i];
                          return CardPreOrderUser(data: data);
                        },
                        separatorBuilder: (_, i) => const SizedBox(height: 5),
                      ),
                    ),
                  ],
                );
              }
            }),
          ),
          if (ref.watch(resetPreOrderUsersNotifier).isLoading)
            const DialogLoading()
        ],
      ),
    );
  }

  void _handleReset() {
    PanaraConfirmDialog.show(
      context,
      message: "Lanjutkan reset data pre-order pengguna ?",
      confirmButtonText: "Lanjutkan",
      cancelButtonText: "Kembali",
      onTapConfirm: () {
        Navigator.of(context).pop();
        ref.read(resetPreOrderUsersNotifier.notifier).reset();
      },
      onTapCancel: Navigator.of(context).pop,
      panaraDialogType: PanaraDialogType.error,
    );
  }

  TextField _buildSearchAppbar() {
    return TextField(
      autofocus: true,
      controller: _searchCtrl,
      cursorColor: Colors.black,
      style: const TextStyle(color: Colors.white, fontSize: 18),
      decoration: const InputDecoration(
        hintText: "Masukkan Kode Pesanan",
        hintStyle: TextStyle(fontSize: 16, color: Colors.white),
        border: UnderlineInputBorder(),
      ),
      onChanged: (value) {
        ref.read(preOrderUsersNotifierProvider.notifier).search(value);
      },
    );
  }
}
