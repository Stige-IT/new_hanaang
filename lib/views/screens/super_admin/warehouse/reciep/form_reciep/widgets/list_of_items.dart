part of '../../reciep.dart';

class ListOfItems extends ConsumerWidget {
  final PageController _pageController;
  const ListOfItems(this._pageController, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(dataNotifier);
    return Expanded(
      child: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 70),
          itemBuilder: (_, i) {
            ItemRecipt item = data[i];
            List<MaterialModel> material = item.recipe!.recipeItem ?? [];
            return Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  title: ExpansionTile(
                    title: Text(
                        "Jumlah Bahan Baku : ${item.recipe?.recipeItem?.length ?? 0}"),
                    children: [
                      for (int i = 0; i < item.recipe!.recipeItem!.length; i++)
                        ListTile(
                          leading: CircleAvatar(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.grey[300],
                            child: Text("${i + 1}"),
                          ),
                          title: Text(material[i].name ?? '-'),
                          trailing: Text(
                              "${item.recipe!.productEstimation ?? 0}  ${material[i].unit}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              )),
                        )
                    ],
                  ),
                  subtitle: Card(
                      child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "Estimasi Produk : ${item.recipe?.productEstimation ?? 0} Cup",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )),
                  onTap: () {
                    _pageController.animateToPage(
                      1,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.bounceIn,
                    );
                  },
                  onLongPress: () {
                    PanaraConfirmDialog.show(
                      context,
                      message: "Yakin hapus resep?",
                      confirmButtonText: "Hapus",
                      cancelButtonText: "kembali",
                      onTapConfirm: () {
                        ref.watch(dataNotifier.notifier).removeData(item.id!);
                        Navigator.of(context).pop();
                      },
                      onTapCancel: Navigator.of(context).pop,
                      panaraDialogType: PanaraDialogType.error,
                    );
                  },
                ),
                const Divider(thickness: 2),
              ],
            );
          },
          separatorBuilder: (_, i) => const SizedBox(height: 7),
          itemCount: data.length,
        ),
      ),
    );
  }
}
