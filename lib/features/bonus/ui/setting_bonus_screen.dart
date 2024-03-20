part of "../bonus.dart";

class SettingBonusScreen extends ConsumerStatefulWidget {
  const SettingBonusScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SettingBonusScreenState();
}

class _SettingBonusScreenState extends ConsumerState<SettingBonusScreen> {
  void _getData() {
    final type = ref.watch(typeIdBonusProvider);
    ref
        .watch(bonusNotifierProvider.notifier)
        .getBonus(title: type, makeLoading: true);
  }

  @override
  void initState() {
    Future.microtask(() => _getData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bonusNotifierProvider);
    final type = ref.watch(typeIdBonusProvider);
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text("Daftar Bonus $type"),
            actions: [
              PopupMenuButton(
                onSelected: (value) {
                  ref
                      .watch(bonusNotifierProvider.notifier)
                      .getBonus(title: value, makeLoading: true);
                  ref.watch(typeIdBonusProvider.notifier).state = value;
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
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      fontWeight: type == title
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                          ),
                        ),
                      )
                      .toList();
                },
              )
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(
                  const Duration(seconds: 1), () => _getData());
            },
            child: Builder(builder: (_) {
              if (state.isLoading) {
                return const Center(child: CircularLoading());
              } else if (ref.watch(bonusNotifierProvider).error != null) {
                return Center(
                  child: ErrorButtonWidget(
                      errorMsg: state.error!, onTap: () => _getData()),
                );
              }
              return const DatatableBonusWidget();
            }),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                  context: context, builder: (_) => const DialogFormBonus());
            },
            child: const Icon(Icons.add),
          ),
        ),
        if (ref.watch(createBonusNotifier).isLoading ||
            ref.watch(updateBonusNotifier).isLoading ||
            ref.watch(deleteBonusNotifier).isLoading)
          const DialogLoading()
      ],
    );
  }
}
