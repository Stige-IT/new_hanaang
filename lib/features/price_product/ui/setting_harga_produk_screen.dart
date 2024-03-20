part of "../price_product.dart";

class SettingHargaProdukScreen extends ConsumerStatefulWidget {
  const SettingHargaProdukScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SettingHargaProdukScreenState();
}

class _SettingHargaProdukScreenState
    extends ConsumerState<SettingHargaProdukScreen> {

  void _getData() {
    final type = ref.watch(typePriceProductProvider);
    ref.watch(priceProductNotifier.notifier).getPrice(type, makeLoading: true);
  }

  @override
  void initState() {
    Future.microtask(() => _getData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final type = ref.watch(typePriceProductProvider);
    final state = ref.watch(priceProductNotifier);
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text("Daftar Harga $type"),
            actions: [
              PopupMenuButton(
                  onSelected: (value) {
                    ref
                        .watch(priceProductNotifier.notifier)
                        .getPrice(value, makeLoading: true);
                    ref.watch(typePriceProductProvider.notifier).state = value;
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
              await Future.delayed(
                  const Duration(seconds: 1), () => _getData());
            },
            child: Builder(builder: (_) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state.error != null) {
                return Center(
                    child: ErrorButtonWidget(
                  errorMsg: state.error!,
                  onTap: () => _getData(),
                ));
              } else {
                return const DatatablePriceProductWidget();
              }
            }),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const DialogFormPriceProduct(),
              );
            },
            child: const Icon(Icons.add),
          ),
        ),
        if (ref.watch(createPriceProdcutNotifier).isLoading ||
            ref.watch(updatePriceProdcutNotifier).isLoading ||
            ref.watch(deletePriceProdcutNotifier).isLoading)
          const DialogLoading()
      ],
    );
  }
}
