import 'package:admin_hanaang/config/router/router_config.dart';
import 'package:admin_hanaang/config/theme.dart';
import 'package:admin_hanaang/features/material/provider/material_provider.dart';
import 'package:admin_hanaang/features/unit/provider/unit_provider.dart';
import 'package:admin_hanaang/models/material_detail.dart';
import 'package:admin_hanaang/models/penerimaan_barang/history_penerimaan_barang.dart';
import 'package:admin_hanaang/models/unit.dart';
import 'package:admin_hanaang/utils/constant/base_url.dart';
import 'package:admin_hanaang/utils/extensions/currency_format.dart';
import 'package:admin_hanaang/utils/helper/formatted_currency.dart';
import 'package:admin_hanaang/views/components/circle_avatar_network.dart';
import 'package:admin_hanaang/views/components/container_address.dart';
import 'package:admin_hanaang/views/components/dropdown_container.dart';
import 'package:admin_hanaang/views/components/form_input.dart';
import 'package:admin_hanaang/views/components/navigation_widget.dart';
import 'package:admin_hanaang/views/components/profile_with_name.dart';
import 'package:admin_hanaang/views/components/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

class DetailMaterialScreen extends ConsumerStatefulWidget {
  final String materialId;

  const DetailMaterialScreen(this.materialId, {super.key});

  @override
  ConsumerState createState() => _DetailMaterialScreenState();
}

class _DetailMaterialScreenState extends ConsumerState<DetailMaterialScreen> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  UnitModel? unitSelected;
  @override
  void initState() {
    Future.microtask(() {
      ref.read(unitsNotifier.notifier).getUnits();
      ref.watch(materialNotifier.notifier).getMaterial(widget.materialId);
      ref.watch(detailSuplayerNotifier.notifier).getDetail(widget.materialId);
      ref
          .watch(historyPenerimaanBarangNotifier.notifier)
          .getHistory(widget.materialId);
    });
    _nameController = TextEditingController();
    _priceController = TextEditingController(text: "0");
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final units = ref.watch(unitsNotifier).data;
    final state = ref.watch(materialNotifier);
    final suplayerData = ref.watch(detailSuplayerNotifier).data;
    MaterialDetail? material = state.data;
    final historyPenerimaanBarang =
        ref.watch(historyPenerimaanBarangNotifier).data;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(material?.name ?? "..."),
          actions: [
            PopupMenuButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                onSelected: (value) {
                  switch (value) {
                    case "edit":
                      _nameController.text = material?.name ?? "";
                      _priceController.text =
                          formatNumber(material?.unitPrice ?? "0");
                      print(material!.unit);
                      showDialog(
                        context: context,
                        builder: (_) => StatefulBuilder(builder: (_, state) {
                          return AlertDialog(
                            insetPadding:
                                const EdgeInsets.symmetric(horizontal: 20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            title: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: const Text("Nama Bahan Baku")),
                            content: Form(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FieldInput(
                                    title: "Nama bahan baku",
                                    hintText: "Masukkan Nama",
                                    controller: _nameController,
                                    textValidator: "",
                                    keyboardType: TextInputType.text,
                                    obsecureText: false,
                                    isRounded: false,
                                  ),
                                  FieldInput(
                                    title: "Harga bahan baku",
                                    hintText: "Masukkan Harga",
                                    controller: _priceController,
                                    textValidator: "",
                                    keyboardType: TextInputType.number,
                                    obsecureText: false,
                                    isRounded: false,
                                    prefixText: "Rp. ",
                                    onChanged: (value) {
                                      if (value.isNotEmpty) {
                                        value = formatNumber(
                                            value.replaceAll(".", ""));
                                        _priceController.value =
                                            TextEditingValue(
                                          text: value,
                                          selection: TextSelection.collapsed(
                                              offset: value.length),
                                        );
                                      }
                                    },
                                  ),
                                  DropdownContainer(
                                    title: "Unit satuan",
                                    value: unitSelected,
                                    items: (units ?? [])
                                        .map((unit) => DropdownMenuItem(
                                            value: unit,
                                            child: Text(unit.name!)))
                                        .toList(),
                                    onChanged: (value) {
                                      state(() {
                                        unitSelected = value;
                                      });
                                    },
                                  )
                                ],
                              ),
                            ),
                            actions: [
                              OutlinedButton(
                                onPressed: Navigator.of(context).pop,
                                child: const Text("Kembali"),
                              ),
                              FilledButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  ref
                                      .read(updateMaterialNotifier.notifier)
                                      .updateMaterial(
                                        material.id!,
                                        name: _nameController.text,
                                        unitId: unitSelected?.id ?? "",
                                        unitPrice: _priceController.text
                                            .replaceAll(".", ""),
                                      )
                                      .then((success) {
                                    if (!success) {
                                      showSnackbar(
                                          context,
                                          ref
                                              .watch(updateMaterialNotifier)
                                              .error!,
                                          isWarning: true);
                                    }
                                  });
                                },
                                child: const Text("Simpan"),
                              )
                            ],
                          );
                        }),
                      );
                      break;
                    case "delete":
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
                              showSnackbar(context,
                                  ref.watch(deleteMaterialsNotifier).error!,
                                  isWarning: true);
                            }
                          });
                        },
                        onTapCancel: Navigator.of(context).pop,
                        panaraDialogType: PanaraDialogType.error,
                      );
                      break;
                  }
                },
                itemBuilder: (_) => [
                      const PopupMenuItem(value: 'edit', child: Text("Edit")),
                      const PopupMenuItem(
                          value: 'delete', child: Text("Hapus")),
                    ]),
          ],
        ),
        body: RefreshIndicator(onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1), () {
            ref.watch(materialNotifier.notifier).getMaterial(widget.materialId);
            ref
                .watch(detailSuplayerNotifier.notifier)
                .getDetail(widget.materialId);
            ref
                .watch(historyPenerimaanBarangNotifier.notifier)
                .refrest(widget.materialId);
          });
        }, child: Builder(builder: (_) {
          if (state.isLoading ||
              ref.watch(updateMaterialNotifier).isLoading ||
              ref.watch(deleteMaterialsNotifier).isLoading) {
            return const LinearProgressIndicator();
          } else {
            if (state.error != null || material == null) {
              return Center(child: Text("${state.error}"));
            } else {
              return ListView(
                children: [
                  ///[Detail data suplayer]
                  ExpansionTile(
                    leading: const Icon(Icons.person),
                    childrenPadding: const EdgeInsets.all(15.0),
                    title: const Text("Detail Suplayer"),
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: suplayerData?.image != null
                            ? ProfileWithName(suplayerData?.name ?? "",
                                radius: 30)
                            : CircleAvatarNetwork(
                                "$BASE/${suplayerData?.image}"),
                        title: Text(suplayerData?.name ?? "",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600)),
                        subtitle: Text(suplayerData?.phoneNumber ?? "-"),
                      ),
                      const SizedBox(height: 5),
                      const Text("Alamat",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      const Divider(thickness: 3),
                      ContainerAddress(
                        label: "Provinsi",
                        value: suplayerData?.address?.province?.name,
                      ),
                      ContainerAddress(
                        label: "Kabupaten",
                        value: suplayerData?.address?.regency?.name,
                      ),
                      ContainerAddress(
                        label: "Kecamatan",
                        value: suplayerData?.address?.district?.name,
                      ),
                      ContainerAddress(
                        label: "Kelurahan",
                        value: suplayerData?.address?.village?.name,
                      ),
                      ContainerAddress(
                        isMultiLine: true,
                        label: "Provinsi",
                        value: suplayerData?.address?.detail,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            color: Theme.of(context).colorScheme.surface,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                children: [
                                  const Text("Total Stok"),
                                  Text(
                                    "${material.stock!} ${material.unit}",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            color: Theme.of(context).colorScheme.surface,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                children: [
                                  const Text("Sisa Stok"),
                                  Text(
                                    "${material.remainingStock!} ${material.unit}",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(thickness: 2),
                  const SizedBox(height: 10),
                  ListTile(
                    title: const Text("Harga Satuan"),
                    trailing:
                        Text(int.parse(material.unitPrice!).convertToIdr()),
                  ),
                  ListTile(
                    title: const Text("Total Harga"),
                    trailing:
                        Text(int.parse(material.totalPrice!).convertToIdr()),
                  ),
                  const Divider(thickness: 2),
                  const SizedBox(height: 10),

                  ///[Detail History Barang Masuk]
                  Builder(builder: (_) {
                    return ExpansionTile(
                      leading: const Icon(Icons.all_inbox_rounded),
                      title: const Text("Riwayat Barang masuk"),
                      children: [
                        if (historyPenerimaanBarang == null ||
                            historyPenerimaanBarang.isEmpty)
                          const Center(
                              child: Column(
                            children: [
                              Icon(Icons.inbox_outlined, size: 50),
                              Text("Data belum ada"),
                            ],
                          ))
                        else
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: ListView.separated(
                              padding: const EdgeInsets.all(10.0),
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (_, i) {
                                HistoryPenerimaanBarang? history =
                                    historyPenerimaanBarang[i];
                                return Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: ListTile(
                                    onTap: () => nextPage(context,
                                        "${AppRoutes.sa}/penerimaan-barang/detail",
                                        argument: history.penerimaanBarangId),
                                    title: const Text("Total Harga",
                                        style: TextStyle(fontSize: 12)),
                                    subtitle: Text(
                                        int.parse(history.price ?? "0")
                                            .convertToIdr(),
                                        style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600)),
                                    trailing: Text("${history.quantity} Item",
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                );
                              },
                              separatorBuilder: (_, i) =>
                                  const SizedBox(height: 5),
                              itemCount: historyPenerimaanBarang.length,
                            ),
                          )
                      ],
                    );
                  }),
                ],
              );
            }
          }
        })));
  }
}
