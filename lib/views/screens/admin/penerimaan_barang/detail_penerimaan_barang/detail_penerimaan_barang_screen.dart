part of "../penerimaan_barang.dart";

class DetailPenerimaanBarangScreenAdmin extends ConsumerStatefulWidget {
  final String dataId;

  const DetailPenerimaanBarangScreenAdmin(this.dataId, {super.key});

  @override
  ConsumerState createState() => _DetailPenerimaanBarangScreenState();
}

class _DetailPenerimaanBarangScreenState
    extends ConsumerState<DetailPenerimaanBarangScreenAdmin> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    Future.microtask(() => ref
        .watch(detailPenerimaanBarangNotifier.notifier)
        .getDetailData(widget.dataId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(detailPenerimaanBarangNotifier);

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: const EndrawerWidget(),
      appBar: AppbarAdmin(
        scaffoldKey: _scaffoldKey,
        title: "Detail Penerimaan Barang",
      ),
      body: RefreshIndicator(onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1), () {});
      }, child: Builder(builder: (_) {
        if (state.isLoading) {
          return Center(child: LoadingInButton(color: Theme.of(context).colorScheme.primary));
        } else if (state.error != null) {
          return ErrorButtonWidget(
            errorMsg: state.error!,
            onTap: () {
              ref
                  .watch(detailPenerimaanBarangNotifier.notifier)
                  .getDetailData(widget.dataId);
            },
          );
        } else if (state.data == null) {
          return const Center(child: Text("Data tidak ditemukan"));
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Card(
                      child: ListTile(
                        title: const Text("No Penerimaan Barang"),
                        subtitle: Text(state.data?.noPenerimaanBarang ?? "-",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            )),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: const Text("Total Harga"),
                        subtitle: Text("Rp. ${formatNumber(state.data?.totalPrice ?? "0")}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            )),
                      ),
                    ),Card(
                      child: ListTile(
                        title: const Text("Dibuat oleh"),
                        subtitle: Text(state.data?.createdBy ?? "-",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Card(
                  child: SingleChildScrollView(
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text("No")),
                        DataColumn(label: Text("Nama Bahan Baku")),
                        DataColumn(label: Text("Jumlah")),
                        DataColumn(label: Text("Total Harga")),
                      ],
                      rows: [
                        for (int i = 0;
                            i < (state.data?.item ?? []).length;
                            i++)
                          DataRow(
                            selected: i % 2 == 0,
                            cells: [
                              DataCell(Text("${i + 1}")),
                              DataCell(Text(
                                  state.data?.item?[i].rawMaterial?.name ??
                                      "-")),
                              DataCell(Text(
                                  "${state.data?.item?[i].quantity} ${state.data?.item?[i].rawMaterial?.unit}")),
                              DataCell(Text(
                                  "Rp. ${formatNumber(state.data?.item?[i].price ?? "0")}")),
                            ],
                          )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      })),
    );
  }
}
