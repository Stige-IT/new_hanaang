part of "../../price_product.dart";

class DatatablePriceProductWidget extends ConsumerStatefulWidget {
  const DatatablePriceProductWidget({super.key});

  @override
  ConsumerState createState() => _DatatablePriceProductWidgetState();
}

class _DatatablePriceProductWidgetState
    extends ConsumerState<DatatablePriceProductWidget> {
  @override
  Widget build(BuildContext context) {
    final type = ref.watch(typePriceProductProvider);
    final data = ref.watch(priceProductNotifier).data;
    return ListView(
      padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 70.0),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: DataTable(
              horizontalMargin: 0,
              headingTextStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              dataTextStyle: Theme.of(context).textTheme.bodySmall,
              dividerThickness: 2,
              columns: const [
                DataColumn(
                  label: FittedBox(
                    child: Text("No", textAlign: TextAlign.center),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text("Minimal \nOrder", textAlign: TextAlign.center),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                      child:
                          Text("Harga \nProduct", textAlign: TextAlign.center)),
                ),
                DataColumn(
                  label: FittedBox(
                    child: Text("Aksi", textAlign: TextAlign.center),
                  ),
                ),
              ],
              rows: List.generate(
                (data ?? []).length,
                (index) => DataRow(cells: [
                  DataCell(Text('${index + 1}')),
                  DataCell(Text('${data![index].minimumOrder} Cup')),
                  DataCell(
                      Text('${int.parse(data[index].price!).convertToIdr()}')),
                  DataCell(Row(
                    children: [
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => DialogFormPriceProduct(
                              priceProductData: data[index],
                            ),
                          );
                        },
                        child: const Card(
                          color: Colors.green,
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: Icon(
                              Icons.edit,
                              size: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          PanaraConfirmDialog.show(
                            context,
                            message:
                                "Apakah Anda yakin  akan menghapus data bonus ini..?",
                            confirmButtonText: "Hapus",
                            cancelButtonText: "Kembali",
                            onTapConfirm: () {
                              Navigator.of(context).pop();
                              ref
                                  .watch(deletePriceProdcutNotifier.notifier)
                                  .deletePrice(data[index].id!)
                                  .then((value) {
                                if (value) {
                                  ref
                                      .watch(priceProductNotifier.notifier)
                                      .getPrice(type);
                                } else {
                                  final error = ref
                                      .watch(deletePriceProdcutNotifier)
                                      .error;
                                  showSnackbar(context, error.toString(),
                                      isWarning: true);
                                }
                              });
                            },
                            onTapCancel: () => Navigator.pop(context),
                            panaraDialogType: PanaraDialogType.error,
                          );
                        },
                        child: const Card(
                          color: Colors.red,
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: Icon(
                              Icons.delete,
                              size: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  )),
                ]),
              ),
            ),
          ),
        ),
        const SizedBox(height: 100),
      ],
    );
  }
}
