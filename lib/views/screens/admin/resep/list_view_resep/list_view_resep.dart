part of "../resep.dart";

class ListViewResep extends ConsumerStatefulWidget {
  const ListViewResep({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ListViewResepState();
}

class _ListViewResepState extends ConsumerState<ListViewResep> {
  late ScrollController _scrollController;

  _getData() => ref.read(reciptsNotifer.notifier).getRecipts(page: 1);

  @override
  void initState() {
    Future.microtask(() => _getData());
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          final page = ref.watch(reciptsNotifer);
          if (page.page < page.lastPage) {
            ref.read(reciptsNotifer.notifier).getMore();
          }
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    ref.invalidate(reciptNotifer);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reciptsNotifer);
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1), () => _getData());
        },
        child: Column(
          children: [
            const ListTile(
                title: Text(
              "Daftar resep dibuat",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )),
            Builder(builder: (_) {
              if (state.isLoading) {
                return Center(
                  child: LoadingInButton(
                      color: Theme.of(context).colorScheme.primary),
                );
              } else if (state.error != null) {
                return ErrorButtonWidget(
                  errorMsg: state.error!,
                  onTap: () => _getData(),
                );
              } else if (state.data == null || state.data!.isEmpty) {
                return const EmptyWidget();
              } else {
                return Expanded(
                  child: Scrollbar(
                    thumbVisibility: true,
                    controller: _scrollController,
                    child: ListView.separated(
                      controller: _scrollController,
                      padding:
                          const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 50.0),
                      itemBuilder: (_, i) {
                        if (state.isLoadingMore && i == state.data?.length) {
                          return Center(
                              child: LoadingInButton(
                            color: Theme.of(context).colorScheme.primary,
                          ));
                        }
                        Recipt recipt = state.data![i];
                        final selectedId =
                            ref.watch(reciptSelectedProvider)?.id;
                        return CardRecipt(
                          selected: selectedId == recipt.id,
                          recipt: recipt,
                          onTap: () {
                            ref
                                .read(reciptNotifer.notifier)
                                .getRecipt(recipt.id!);
                            ref.read(reciptSelectedProvider.notifier).state =
                                recipt;
                          },
                        );
                      },
                      separatorBuilder: (_, i) => const SizedBox(height: 5),
                      itemCount: state.isLoadingMore
                          ? (state.data ?? []).length + 1
                          : (state.data ?? []).length,
                    ),
                  ),
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}
