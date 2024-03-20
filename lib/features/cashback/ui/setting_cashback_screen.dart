part of "../cashback.dart";

class SettingCashbackScreen extends ConsumerStatefulWidget {
  const SettingCashbackScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SettingCashbackScreenState();
}

class _SettingCashbackScreenState extends ConsumerState<SettingCashbackScreen> {
  void _getData() {
    final type = ref.watch(typeIdCashbackProvider);
    ref
        .watch(cashbackNotifier.notifier)
        .getCashback(title: type, makeLoading: true);
  }

  @override
  void initState() {
    Future.microtask(() => _getData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cashbackNotifier);
    final type = ref.watch(typeIdCashbackProvider);
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text("Daftar Cashback $type"),
            actions: [
              PopupMenuButton(
                  onSelected: (value) {
                    ref
                        .watch(cashbackNotifier.notifier)
                        .getCashback(title: value, makeLoading: true);
                    ref.watch(typeIdCashbackProvider.notifier).state = value;
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  icon: const Icon(Icons.filter_alt),
                  itemBuilder: (_) {
                    return typeUser
                        .map(
                          (title) => PopupMenuItem(
                            value: title,
                            child: Text(
                              title,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    fontWeight: type == title
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                            ),
                          ),
                        )
                        .toList();
                  })
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              Future.delayed(const Duration(seconds: 1), () => _getData());
            },
            child: Builder(builder: (_) {
              if (state.isLoading) {
                return const Center(child: CircularLoading());
              } else if (state.error != null) {
                return Center(
                  child: ErrorButtonWidget(
                      errorMsg: state.error!, onTap: () => _getData()),
                );
              }
              return const DatatableCashbackWidget();
            }),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const DialogFormCashback(),
              );
            },
            child: const Icon(Icons.add),
          ),
        ),
        if (ref.watch(createCashbackNotifier).isLoading ||
            ref.watch(updateCashbackNotifier).isLoading ||
            ref.watch(deleteCashbackNotifier).isLoading)
          const DialogLoading()
      ],
    );
  }
}
