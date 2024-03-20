part of "../resep.dart";

class DetailResep extends ConsumerStatefulWidget {
  const DetailResep({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DetailResepState();
}

class _DetailResepState extends ConsumerState<DetailResep> {
  @override
  Widget build(BuildContext context) {
    final recipt = ref.watch(reciptNotifer);
    return Expanded(
      flex: 2,
      child: Builder(builder: (context) {
        if (recipt.isLoading) {
          return Center(child: LoadingInButton(color: Theme.of(context).colorScheme.primary));
        } else if (recipt.error != null) {
          return ErrorButtonWidget(
            errorMsg: recipt.error!,
            onTap: () {
              final reciptId = ref.watch(reciptSelectedProvider)?.id;
              ref.read(reciptNotifer.notifier).getRecipt(reciptId!);
            },
          );
        } else if (recipt.data == null) {
          return const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              EmptyWidget(),
              SizedBox(height: 5),
              Text("Klik resep terlebih dahulu"),
            ],
          );
        }
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                title: const Text(
                  "Detail Resep",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "Dibuat pada tanggal : ${recipt.data!.createdAt!.dateFormatWithDay()}"),
                    const SizedBox(height: 10),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Colors.black),
                        children: [
                          const TextSpan(text: "Estimasi Produk: "),
                          TextSpan(
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            text:
                                "${formatNumber(recipt.data?.productEstimation ?? "0")} Cup ",
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                trailing: Text(
                  "Dibuat oleh:\n${recipt.data?.createdBy?.name}",
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Card(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text("No")),
                        DataColumn(label: Text("Nama")),
                        DataColumn(label: Text("kuantitas")),
                        DataColumn(label: Text("Harga satuan")),
                        DataColumn(label: Text("Total Harga")),
                      ],
                      rows: [
                        for (int i = 0;
                            i < recipt.data!.recipeItem!.length;
                            i++)
                          DataRow(
                            selected: i % 2 == 0,
                            cells: [
                              DataCell(Text("${i + 1}")),
                              DataCell(
                                Text(recipt.data?.recipeItem?[i].name ?? "-"),
                              ),
                              DataCell(
                                Text(
                                    "${recipt.data?.recipeItem?[i].quantity ?? "-"} ${recipt.data?.recipeItem?[i].unit ?? "-"}"),
                              ),
                              DataCell(Text(int.parse(
                                      recipt.data?.recipeItem?[i].price ?? "0")
                                  .convertToIdr())),
                              DataCell(Text(int.parse(
                                      recipt.data?.recipeItem?[i].totalPrice ??
                                          "0")
                                  .convertToIdr())),
                            ],
                          )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
