part of "../../cashback.dart";

class DatatableCashbackWidget extends ConsumerStatefulWidget {
  const DatatableCashbackWidget({super.key});

  @override
  ConsumerState createState() => _DatatableCashbackWidgetState();
}

class _DatatableCashbackWidgetState
    extends ConsumerState<DatatableCashbackWidget> {
  @override
  Widget build(BuildContext context) {
    final data = ref.watch(cashbackNotifier).data;
    return ListView(
      padding: const EdgeInsets.fromLTRB(5, 5, 5, 70),
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: DataTable(
              horizontalMargin: 0,
              headingTextStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.w600,
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
                        Text("Jumlah \nCashback", textAlign: TextAlign.center),
                  ),
                ),
                DataColumn(
                  label: FittedBox(
                    child: Text("Aksi", textAlign: TextAlign.center),
                  ),
                ),
              ],
              rows: List.generate((data ?? []).length, (index) {
                Cashback? item = data?[index];
                return DataRow(cells: [
                  DataCell(Text('${index + 1}')),
                  DataCell(Text(item?.minimumOrder ?? "")),
                  DataCell(
                    Text(
                        '${int.parse(item?.numberOfCashback ?? "0").convertToIdr()}'),
                  ),
                  DataCell(Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => DialogFormCashback(cashbackData: item),
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
                                  .watch(deleteCashbackNotifier.notifier)
                                  .delete(item!.id!)
                                  .then((succes) {
                                if (!succes) {
                                  final msg =
                                      ref.watch(deleteCashbackNotifier).error;
                                  showSnackbar(context, msg!, isWarning: true);
                                }
                              });
                            },
                            onTapCancel: Navigator.of(context).pop,
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
                      ),
                    ],
                  )),
                ]);
              }),
            ),
          ),
        ),
      ],
    );
  }
}
