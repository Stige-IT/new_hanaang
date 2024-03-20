part of "../../bonus.dart";

class DatatableBonusWidget extends ConsumerStatefulWidget {
  const DatatableBonusWidget({super.key});

  @override
  ConsumerState createState() => _DatatableBonusWidgetState();
}

class _DatatableBonusWidgetState extends ConsumerState<DatatableBonusWidget> {
  @override
  Widget build(BuildContext context) {
    final dataBonus = ref.watch(bonusNotifierProvider).data;
    return ListView(
      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 70.0),
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Container(
            padding: const EdgeInsets.all(10.0),
            width: double.infinity,
            child: DataTable(
              horizontalMargin: 0,
              headingTextStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              dataTextStyle: Theme.of(context).textTheme.bodySmall,
              dividerThickness: 2,
              columns: const [
                DataColumn(
                  label: Expanded(
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
                          Text("Jumlah \nBonus", textAlign: TextAlign.center)),
                ),
                DataColumn(
                  label: FittedBox(
                    child: Text(
                      "Aksi",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
              rows: List.generate(
                (dataBonus ?? []).length,
                (index) => DataRow(
                  cells: [
                    DataCell(Text('${index + 1}')),
                    DataCell(Text('${dataBonus?[index].minimumOrder} Cup')),
                    DataCell(Text('${dataBonus?[index].numberOfBonus} Cup')),
                    DataCell(
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (_) => DialogFormBonus(
                                  bonusData: dataBonus![index],
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
                                      .watch(deleteBonusNotifier.notifier)
                                      .deleteBonus(dataBonus![index].id!)
                                      .then((succes) {
                                    if (!succes) {
                                      final msg =
                                          ref.watch(deleteBonusNotifier).error;
                                      showSnackbar(context, msg!,
                                          isWarning: true);
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
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
