part of "../reciep.dart";

class FormReciptScreen extends ConsumerStatefulWidget {
  const FormReciptScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FormReciptScreenState();
}

class _FormReciptScreenState extends ConsumerState<FormReciptScreen> {
  late PageController _pageController;

  @override
  void initState() {
    Future.microtask(() async {
      ref.watch(materialsNotifier.notifier).getMaterials();
    });
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    ref.invalidate(dataNotifier);
    super.dispose();
  }

  int sumTotalPrice(List<Map<String, dynamic>> data) {
    int total = 0;
    for (var item in data) {
      total += int.parse(item['price']);
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(materialsNotifier);
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: const Text("Tambah Resep"),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 1), () {});
            },
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Column(
                  children: [
                    ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 15.0),
                      title: const Text("Bahan baku"),
                      trailing: FilledButton.icon(
                        onPressed: () {
                          _pageController.animateToPage(
                            1,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.bounceIn,
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: state.isLoading
                            ? const LoadingInButton()
                            : const Text("Tambah Item"),
                      ),
                    ),
                    const Divider(thickness: 3),
                    ListOfItems(_pageController),
                    const BottomSheetReciep(),
                  ],
                ),
                FormRecipt(_pageController),
              ],
            ),
          ),
        ),
        if (ref.watch(createReciptNotifer).isLoading) const DialogLoading()
      ],
    );
  }
}
