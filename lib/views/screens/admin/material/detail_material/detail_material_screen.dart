part of "../material.dart";

class DetailMaterialScreenAdmin extends ConsumerStatefulWidget {
  final String materialId;

  const DetailMaterialScreenAdmin(this.materialId, {super.key});

  @override
  ConsumerState createState() => _DetailMaterialScreenAdminState();
}

class _DetailMaterialScreenAdminState
    extends ConsumerState<DetailMaterialScreenAdmin> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    Future.microtask(() =>
        ref.read(materialNotifier.notifier).getMaterial(widget.materialId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(materialNotifier);
    MaterialDetail? material = state.data;
    return Scaffold(
      key: _scaffoldKey,
      appBar:
          AppbarAdmin(scaffoldKey: _scaffoldKey, title: "Detail Bahan Baku"),
      endDrawer: const EndrawerWidget(),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1), () {
            ref.read(materialNotifier.notifier).getMaterial(widget.materialId);
          });
        },
        child: Builder(builder: (_) {
          if (state.isLoading) {
            return Center(child: LoadingInButton(color: Theme.of(context).colorScheme.primary));
          } else if (state.error != null) {
            return ErrorButtonWidget(
              errorMsg: state.error!,
              onTap: () {
                ref
                    .read(materialNotifier.notifier)
                    .getMaterial(widget.materialId);
              },
            );
          }
          return ListView(
            padding: const EdgeInsets.all(25.0),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: ListTile(
                      leading: const Icon(Icons.padding, size: 50),
                      title: const Text("Nama Bahan Baku"),
                      subtitle: Text(
                        material?.name ?? "-",
                        style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CardTotalStock(
                          title: "Total Stok",
                          value: material?.stock ?? "0",
                          unit: material?.unit ?? "-",
                        ),
                        CardTotalStock(
                          title: "Sisa Stok",
                          value: material?.remainingStock ?? "0",
                          unit: material?.unit ?? "-",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 25),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      FilledButton.icon(
                        onPressed: () => nextPage(
                          context,
                          "${AppRoutes.admin}/material/form",
                          argument: MaterialModel(
                            id: material?.id,
                            name: material?.name,
                            unit: material?.unit,
                            stock: material?.stock,
                            remainingStock: material?.remainingStock,
                            unitPrice: material?.unitPrice,
                            totalPrice: material?.totalPrice,
                          ),
                        ),
                        icon: const Icon(Icons.edit),
                        label: const Text("Edit"),
                      ),
                      const SizedBox(width: 10),
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () {
                          PanaraConfirmDialog.show(
                            context,
                            message: "Hapus Bahan Baku ini ?",
                            confirmButtonText: "Hapus",
                            cancelButtonText: "Kembali",
                            onTapConfirm: () {
                              Navigator.of(context).pop();
                              ref
                                  .read(deleteMaterialsNotifier.notifier)
                                  .deleteMaterial(material!.id!)
                                  .then((success) {
                                if (success) {
                                  Navigator.of(context).pop();
                                  showSnackbar(
                                      context, "Bahan baku berhasil dihapus");
                                } else {
                                  final err =
                                      ref.watch(deleteMaterialsNotifier).error;
                                  showSnackbar(context, err!, isWarning: true);
                                }
                              });
                            },
                            onTapCancel: Navigator.of(context).pop,
                            panaraDialogType: PanaraDialogType.error,
                          );
                        },
                        icon: const Icon(Icons.delete),
                        label: ref.watch(deleteMaterialsNotifier).isLoading
                            ? const LoadingInButton()
                            : const Text("Hapus"),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        ListTile(
                          title: const Text(
                            "Dibuat Oleh:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: TextButton(
                            onPressed: () => nextPage(
                                context, "${AppRoutes.admin}/suplayer/detail",
                                argument: material?.suplayer?.id),
                            child: const Text("Detail"),
                          ),
                        ),
                        Card(
                          child: ListTile(
                            leading: Builder(builder: (_) {
                              if (material?.suplayer?.image == null) {
                                return ProfileWithName(
                                    material?.suplayer?.name ?? "--");
                              } else {
                                return CircleAvatarNetwork(
                                    "$BASE/${material?.suplayer?.image}");
                              }
                            }),
                            title: Text(material?.suplayer?.name ?? '-'),
                          ),
                        ),
                        Card(
                          child: ListTile(
                            leading: const Icon(Icons.phone, size: 35),
                            title: Text(material?.suplayer?.phoneNumber ?? "-"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 25),
                  Expanded(
                    child: Column(
                      children: [
                        const ListTile(
                          title: Text(
                            "Data bahan baku:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        ListTile(
                          title: const Text("Nama Bahan baku"),
                          trailing: Text(
                            material?.name ?? "-",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        ListTile(
                          title: const Text("Unit Satuan"),
                          trailing: Text(
                            material?.unit ?? "-",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        ListTile(
                          title: const Text("Total Stok"),
                          trailing: Text(
                            material?.stock ?? "-",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        ListTile(
                          title: const Text("Sisa Stok"),
                          trailing: Text(
                            material?.remainingStock ?? "-",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        ListTile(
                          title: const Text("Harga Satuan"),
                          trailing: Text(
                            formatNumber(material?.unitPrice ?? "0"),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        ListTile(
                          title: const Text("Total Harga"),
                          trailing: Text(
                            formatNumber(material?.totalPrice ?? "0"),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          );
        }),
      ),
    );
  }
}
