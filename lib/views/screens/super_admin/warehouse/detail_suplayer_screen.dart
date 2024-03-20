import 'package:admin_hanaang/config/router/router_config.dart';
import 'package:admin_hanaang/features/suplayer/provider/suplayer_provider.dart';
import 'package:admin_hanaang/models/suplayer.dart';
import 'package:admin_hanaang/views/components/appbar.dart';
import 'package:admin_hanaang/views/components/label.dart';
import 'package:admin_hanaang/views/components/navigation_widget.dart';
import 'package:admin_hanaang/views/components/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import '../../../../config/theme.dart';
import '../../../../utils/constant/base_url.dart';
import '../../../components/container_address.dart';

class DetailSuplayerScreen extends ConsumerStatefulWidget {
  final Suplayer suplayer;

  const DetailSuplayerScreen(this.suplayer, {super.key});

  @override
  ConsumerState createState() => _DetailSuplayerScreenState();
}

class _DetailSuplayerScreenState extends ConsumerState<DetailSuplayerScreen> {
  @override
  void initState() {
    Future.microtask(() {
      ref.watch(suplayerByIdNotifier.notifier).getSuplayer(widget.suplayer.id!);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(suplayerByIdNotifier);
    final Suplayer? suplayer = state.data;
    return Scaffold(
      bottomSheet: ref.watch(deleteSuplayerNotifier).isLoading
          ? const LinearProgressIndicator()
          : null,
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1), () {
            ref
                .watch(suplayerByIdNotifier.notifier)
                .getSuplayer(widget.suplayer.id!);
          });
        },
        child: CustomScrollView(
          slivers: [
            AppBarSliver(
              title: "Profil Suplayer",
              actions: [
                PopupMenuButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    onSelected: _handlePopMenuItem,
                    itemBuilder: (_) => [
                          const PopupMenuItem(
                              value: "edit", child: Text("Edit")),
                          const PopupMenuItem(
                              value: "delete", child: Text("Hapus")),
                        ]),
              ],
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: state.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : state.error != null
                        ? Center(
                            child: Column(
                            children: [
                              const Icon(Icons.warning_amber, size: 50),
                              const SizedBox(height: 10),
                              Text(state.error!),
                            ],
                          ))
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                visualDensity: const VisualDensity(vertical: 4),
                                leading: Column(
                                  children: [
                                    if (suplayer?.image == null)
                                      CircleAvatar(
                                        radius: 25,
                                        backgroundColor: Theme.of(context).colorScheme.primary,
                                        foregroundColor: Colors.white,
                                        child: Text(
                                          suplayer?.name![0] ?? '',
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    else
                                      CircleAvatar(
                                        radius: 25,
                                        backgroundImage: NetworkImage(
                                            "$BASE/${suplayer!.image}"),
                                      ),
                                  ],
                                ),
                                title: Text(
                                  suplayer?.name ?? '-',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                    suplayer?.phoneNumber ?? "No.Telepon: -"),
                              ),
                              Wrap(
                                children: (suplayer?.rawMaterial ?? [])
                                    .map(
                                      (material) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: InkWell(
                                            onTap: () => nextPage(context,
                                                "${AppRoutes.sa}/material/detail",
                                                argument: material.id),
                                            child: SizedBox(
                                              width: 100,
                                              height: 25,
                                              child: Label(
                                                  title: material.name,
                                                  status: 'partial'),
                                            )),
                                      ),
                                    )
                                    .toList(),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "Alamat",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                              const Divider(thickness: 2),
                              const SizedBox(height: 5),
                              ContainerAddress(
                                label: "Provinsi",
                                value: suplayer?.address?.province?.name,
                              ),
                              ContainerAddress(
                                label: "Provinsi",
                                value: suplayer?.address?.regency?.name,
                              ),
                              ContainerAddress(
                                label: "Provinsi",
                                value: suplayer?.address?.district?.name,
                              ),
                              ContainerAddress(
                                label: "Provinsi",
                                value: suplayer?.address?.village?.name,
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                "Detail Alamat",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                              const Divider(thickness: 2),
                              ContainerAddress(
                                value: suplayer?.address?.detail,
                                isMultiLine: true,
                              )
                            ],
                          ),
              )
            ]))
          ],
        ),
      ),
    );
  }

  void _handlePopMenuItem(String value) {
    final suplayer = ref.watch(suplayerByIdNotifier).data;
    switch (value) {
      case "edit":
        nextPage(context, "${AppRoutes.sa}/suplayer/form", argument: suplayer);
        break;
      case "delete":
        PanaraConfirmDialog.show(
          context,
          message: "Lanjutkan hapus suplayer ini?",
          confirmButtonText: "Hapus",
          cancelButtonText: "kembali",
          onTapConfirm: () {
            Navigator.of(context).pop();
            ref
                .watch(deleteSuplayerNotifier.notifier)
                .deleteSuplayer(suplayer!.id!)
                .then((success) {
              if (success) {
                showSnackbar(context, "berhasil menghapus suplayer");
                Navigator.pop(context);
              } else {
                showSnackbar(
                  context,
                  ref.watch(deleteSuplayerNotifier).error!,
                  isWarning: true,
                );
              }
            });
          },
          onTapCancel: Navigator.of(context).pop,
          panaraDialogType: PanaraDialogType.error,
        );
        break;
      default:
    }
  }
}
