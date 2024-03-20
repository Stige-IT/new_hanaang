part of "../penerimaan_barang.dart";

class PenerimaanBarangScreenAdmin extends ConsumerStatefulWidget {
  const PenerimaanBarangScreenAdmin({super.key});

  @override
  ConsumerState createState() => _PenerimaanBarangScreenAdminState();
}

class _PenerimaanBarangScreenAdminState
    extends ConsumerState<PenerimaanBarangScreenAdmin> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    Future.microtask(() => ref
        .watch(penerimaanBarangNotifier.notifier)
        .getData(makeLoading: true));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(penerimaanBarangNotifier);
    final data = state.data;
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: const EndrawerWidget(),
      appBar: AppbarAdmin(
        isMain: true,
        scaffoldKey: _scaffoldKey,
        title: "Penerimaan Barang",
      ),
      body: RefreshIndicator(onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1), () {
          ref
              .watch(penerimaanBarangNotifier.notifier)
              .getData(makeLoading: true);
        });
      }, child: Builder(builder: (_) {
        if (state.errorMessage != null) {
          return ErrorButtonWidget(errorMsg: state.errorMessage!, onTap: (){
            ref.read(penerimaanBarangNotifier.notifier).getData(initPage : 1,makeLoading: true);
          },);
        } else if (state.data == null || state.data!.isEmpty) {
          return const EmptyWidget();
        } else {
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if(state.isLoading != null && state.isLoading!)
                      LoadingInButton(color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 10),
                    FilledButton.icon(
                      onPressed: () => nextPage(
                          context, "${AppRoutes.admin}/penerimaan-barang/form"),
                      icon: const Icon(Icons.add),
                      label: const Text("Tambah Penerimaan barang"),
                    ),
                  ],
                ),
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: Card(
                      child: SingleChildScrollView(
                        child: DataTable(
                          showCheckboxColumn: false,
                          columns: const [
                            DataColumn(label: Text("No")),
                            DataColumn(label: Text("Tanggal penerimaan")),
                            DataColumn(label: Text("No.Penerimaan")),
                            DataColumn(label: Text("Total Harga")),
                          ],
                          rows: [
                            for (int i = 0; i < (data ?? []).length; i++)
                              DataRow(
                                  onSelectChanged: (_) {
                                    nextPage(context,
                                        "${AppRoutes.admin}/penerimaan-barang/detail",
                                        argument: data[i].id);
                                  },
                                  selected: i % 2 == 0,
                                  cells: [
                                    DataCell(Text("${i + 1}")),
                                    DataCell(
                                        Text(data![i].createdAt!.timeFormat())),
                                    DataCell(Text(
                                      data[i].noPenerimaanBarang ?? "-",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    )),
                                    DataCell(Text(
                                        int.parse(data[i].totalPrice ?? "0")
                                            .convertToIdr())),
                                  ])
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        int page =
                            ref.watch(penerimaanBarangNotifier).page!;
                        if (page > 1) {
                          ref
                              .watch(penerimaanBarangNotifier.notifier)
                              .getData(initPage: page -1, makeLoading: true);
                        }
                      },
                    ),
                    Text(
                        'Page ${ref.watch(penerimaanBarangNotifier).page} of ${ref.watch(penerimaanBarangNotifier).totalPage}'),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () {
                        final page = ref.watch(penerimaanBarangNotifier);
                        if (page.page! < page.totalPage!) {
                          ref.read(penerimaanBarangNotifier.notifier).getData(initPage: page.page! + 1, makeLoading: true);
                        }
                      },
                    ),
                  ],
                )
              ],
            ),
          );
        }
      })),
    );
  }
}
