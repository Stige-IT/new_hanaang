part of "../material.dart";

class DataTableMaterial extends ConsumerWidget {
  const DataTableMaterial({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataMaterial = ref.watch(materialsNotifier).data;
    final dataSearch = ref.watch(searchMaterialsNotifier);
    final isShowSearch = ref.watch(isShowSearchProvider);
    return Expanded(
      child: Card(
        child: SingleChildScrollView(
          child: DataTable(
              showCheckboxColumn: false,
              showBottomBorder: true,
              columns: const [
                DataColumn(label: Text("No")),
                DataColumn(label: Text("Nama bahan baku")),
                DataColumn(label: Text("Total")),
                DataColumn(label: Text("Sisa")),
                DataColumn(label: Text("Harga satuan")),
                DataColumn(label: Text("Total Harga")),
              ],
              rows: List.generate((isShowSearch ? dataSearch: dataMaterial ?? []).length, (i) {
                MaterialModel? material = isShowSearch ? dataSearch[i]: dataMaterial?[i];
                return DataRow(
                  selected: i % 2 == 0,
                  onSelectChanged: (selected) {
                    nextPage(context, "${AppRoutes.admin}/material/detail",
                        argument: material!.id);
                  },
                  cells: [
                    DataCell(Text("${i + 1}")),
                    DataCell(Text(material?.name ?? "-")),
                    DataCell(Text("${material?.stock ?? 0} ${material?.unit}")),
                    DataCell(Text("${material?.remainingStock ?? 0} ${material?.unit}")),
                    DataCell(Text(int.parse(material?.unitPrice ?? "0").convertToIdr() ?? "-")),
                    DataCell(Text(int.parse(material?.totalPrice ?? "0").convertToIdr() ?? "-")),
                  ],
                );
              })),
        ),
      ),
    );
  }
}
