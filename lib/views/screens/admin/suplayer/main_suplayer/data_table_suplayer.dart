part of "../suplayer.dart";

class DataTableSuplayer extends ConsumerStatefulWidget {
  const DataTableSuplayer({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DataTableSuplayerState();
}

class _DataTableSuplayerState extends ConsumerState<DataTableSuplayer> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final dataSuplayer = ref.watch(suplayerNotifier).data;
    return Expanded(
      child: Card(
        child: SingleChildScrollView(
          child: DataTable(
              showCheckboxColumn: false,
              showBottomBorder: true,
              columns: const [
                DataColumn(label: Text("No")),
                // DataColumn(label: Text("Foto")),
                DataColumn(label: Text("Nama")),
                DataColumn(label: Text("No.Telepon")),
                DataColumn(label: Text("Action")),
              ],
              rows: List.generate((dataSuplayer ?? []).length, (i) {
                Suplayer? suplayer = dataSuplayer?[i];
                return DataRow(
                  selected: i % 2 == 0,
                  onSelectChanged: (selected) {
                    nextPage(context, "${AppRoutes.admin}/suplayer/detail",
                        argument: suplayer!.id);
                  },
                  cells: [
                    DataCell(Text("${i + 1}")),
                    // DataCell(
                    //   (suplayer?.image != null)
                    //       ? CircleAvatarNetwork("$BASE/${suplayer?.image}")
                    //       : ProfileWithName(suplayer?.name ?? "--"),
                    // ),
                    DataCell(
                      Text(
                        suplayer?.name ?? "-",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    DataCell(Text(suplayer?.phoneNumber ?? "-")),
                    DataCell(Row(
                      children: [
                        SizedBox(
                          width: size.width * 0.05,
                          child: FilledButton(
                            onPressed: () => nextPage(
                              context,
                              "${AppRoutes.admin}/suplayer/form",
                              argument: suplayer,
                            ),
                            child: const Icon(Icons.edit),
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: size.width * 0.05,
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () => dialogDelete(
                              context,
                              ref,
                              suplayerId: suplayer!.id!,
                            ),
                            child: const Icon(Icons.delete),
                          ),
                        )
                      ],
                    )),
                  ],
                );
              })),
        ),
      ),
    );
  }
}
