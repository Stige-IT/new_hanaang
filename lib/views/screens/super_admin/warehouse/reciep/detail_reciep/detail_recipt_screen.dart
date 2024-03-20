part of "../reciep.dart";

class DetailReciptScreen extends ConsumerStatefulWidget {
  final String reciptId;
  const DetailReciptScreen(this.reciptId, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DetailReciptScreenState();
}

class _DetailReciptScreenState extends ConsumerState<DetailReciptScreen> {
  @override
  void initState() {
    Future.microtask(
        () => ref.read(reciptNotifer.notifier).getRecipt(widget.reciptId));
    super.initState();
  }

  String totalPrice() {
    final recipes = ref.watch(reciptNotifer).data;
    int total = 0;
    if (recipes != null) {
      for (RecipeItem material in recipes.recipeItem!) {
        total += int.parse(material.totalPrice!);
      }
    }
    return formatNumber(total.toString());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reciptNotifer);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text("Detail Resep"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1), () {
            ref.read(reciptNotifer.notifier).getRecipt(widget.reciptId);
          });
        },
        child: Builder(builder: (_) {
          if (state.isLoading) {
            return Center(child: LoadingInButton(color: Theme.of(context).colorScheme.primary));
          } else if (state.error != null) {
            return Center(child: Text(state.error!));
          } else if (state.data == null) {
            return const EmptyWidget();
          }
          return Padding(
            padding: EdgeInsets.fromLTRB(
                5.0, 5.0, 5.0, MediaQuery.of(context).viewInsets.bottom + 170),
            child: Column(
              children: [
                ListTile(
                  visualDensity: const VisualDensity(vertical: -3),
                  title: const Text("Tanggal"),
                  trailing: Text((state.data?.createdAt ?? "").timeFormat()),
                ),
                ListTile(
                  visualDensity: const VisualDensity(vertical: -3),
                  title: const Text("Dibuat oleh : "),
                  trailing: Text(
                    "${state.data?.createdBy?.name}",
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                const ListTile(
                  visualDensity: VisualDensity(vertical: -3),
                  title: Text(
                    "Bahan baku",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(thickness: 2),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ListView(
                        children: [
                          DataTable(
                            showBottomBorder: true,
                            horizontalMargin: 0,
                            columns: const [
                              DataColumn(label: Text("Bahan Baku")),
                              DataColumn(label: Text("Quantity")),
                              DataColumn(label: Text("Harga")),
                            ],
                            rows: (state.data?.recipeItem ?? [])
                                .map((item) => DataRow(cells: [
                                      DataCell(Text(item.name ?? "-")),
                                      DataCell(
                                          Text("${item.quantity ?? 0} cup")),
                                      DataCell(
                                        Text(int.parse(item.totalPrice ?? "0")
                                            .convertToIdr()),
                                      ),
                                    ]))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        }),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: const Offset(2, -5),
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.local_drink, size: 50, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 15.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Estimasi Produk"),
                    Text(
                      "${state.data?.productEstimation ?? 0} Cup",
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.money, size: 50, color: Colors.green),
                const SizedBox(width: 15.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Total Harga"),
                    Text(
                      "Rp. ${totalPrice()}",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
