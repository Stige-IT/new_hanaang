part of "../reciep.dart";

class ReciptScreen extends ConsumerStatefulWidget {
  const ReciptScreen({super.key});

  @override
  ConsumerState createState() => _ReciptScreenState();
}

class _ReciptScreenState extends ConsumerState<ReciptScreen> {
  late ScrollController _scrollController;
  @override
  void initState() {
    Future.microtask(() => ref.read(reciptsNotifer.notifier).refresh());
    _scrollController = ScrollController()
      ..addListener(() {
        final position = _scrollController.position.pixels;
        final maxPosition = _scrollController.position.maxScrollExtent;
        if (position == maxPosition) {
          final page = ref.watch(reciptsNotifer).page;
          final lastPage = ref.watch(reciptsNotifer).lastPage;
          if (page != lastPage) {
            ref.read(reciptsNotifer.notifier).getMore();
          }
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reciptsNotifer);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text("Resep"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1), () {
            ref.read(reciptsNotifer.notifier).refresh();
          });
        },
        child: Builder(builder: (_) {
          if (state.isLoading) {
            return Center(child: LoadingInButton(color: Theme.of(context).colorScheme.primary));
          } else if (state.error != null) {
            return ErrorButtonWidget(errorMsg: state.error!);
          } else if (state.data == null || state.data!.isEmpty) {
            return const EmptyWidget();
          }
          return ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 70.0),
            itemBuilder: (_, i) {
              if (state.isLoadingMore && i == state.data?.length) {
                return Center(
                    child: LoadingInButton(color: Theme.of(context).colorScheme.primary));
              }
              Recipt? recipt = state.data?[i];
              return CardRecipt(recipt: recipt);
            },
            separatorBuilder: (_, i) => const SizedBox(height: 5),
            itemCount: state.isLoadingMore
                ? (state.data ?? []).length + 1
                : (state.data ?? []).length,
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => nextPage(context, "${AppRoutes.sa}/recipt/create"),
        child: const Icon(Icons.add),
      ),
    );
  }
}
