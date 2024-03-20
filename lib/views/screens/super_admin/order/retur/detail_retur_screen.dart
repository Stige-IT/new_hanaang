import 'package:admin_hanaang/utils/constant/base_url.dart';
import 'package:admin_hanaang/utils/extensions/currency_format.dart';
import 'package:admin_hanaang/utils/extensions/date_formater.dart';
import 'package:admin_hanaang/views/components/dialog_loading.dart';
import 'package:admin_hanaang/views/components/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:photo_view/photo_view.dart';

import '../../../../../config/theme.dart';
import '../../../../../features/retur/provider/retur_provider.dart';
import '../../../../../models/retur.dart';
import '../../../../../utils/helper/checkStatusLabel.dart';
import '../../../../components/form_input.dart';
import '../../../../components/label.dart';

class DetailReturScreen extends ConsumerStatefulWidget {
  final Retur dataRetur;

  const DetailReturScreen(this.dataRetur, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DetailReturScreenState();
}

class _DetailReturScreenState extends ConsumerState<DetailReturScreen> {
  final _formKey = GlobalKey<FormState>();
  final _formKeyDialog = GlobalKey<FormState>();
  late TextEditingController _messageRejectController;
  late TextEditingController _quantityCtrl;

  @override
  void initState() {
    _messageRejectController = TextEditingController();
    _quantityCtrl = TextEditingController(text: "0");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              title: const Text("Detail Retur Produk"),
            ),
            body: ListView(children: [
              ///[*Detail pesanan]
              ExpansionTile(
                backgroundColor: Theme.of(context).colorScheme.surface,
                collapsedBackgroundColor: Theme.of(context).colorScheme.surface,
                textColor: Colors.black,
                leading: const Icon(Icons.shopping_bag_outlined),
                title: const Text("Detail Pesanan"),
                children: [
                  ListTile(
                    visualDensity: const VisualDensity(vertical: -3),
                    title: const Text("Tanggal Pemesanan"),
                    trailing: Text(
                        "${widget.dataRetur.order!.createdAt!.dateFormatWithDay()}"),
                  ),
                  ListTile(
                    visualDensity: const VisualDensity(vertical: -3),
                    title: const Text("No Pesanan"),
                    trailing: Text(
                      "${widget.dataRetur.order!.orderNumber}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  ListTile(
                    visualDensity: const VisualDensity(vertical: -3),
                    title: const Text("Total Pesan"),
                    trailing:
                        Text("${widget.dataRetur.order?.totalOrder ?? 0} Cup"),
                  ),
                  ListTile(
                    visualDensity: const VisualDensity(vertical: -3),
                    title: const Text("Total Bayar"),
                    trailing: Text(widget.dataRetur.order?.totalPrice?.convertToIdr()),
                  ),
                ],
              ),

              ///[*Data Retur]
              ListTile(
                visualDensity: const VisualDensity(vertical: -3),
                title: const Text("Tanggal retur"),
                trailing: Text(widget.dataRetur.date!.dateFormatWithDay()),
              ),
              ListTile(
                visualDensity: const VisualDensity(vertical: -3),
                title: const Text("No.Retur"),
                trailing: Text(
                  widget.dataRetur.returNumber ?? "-",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              ListTile(
                visualDensity: const VisualDensity(vertical: -3),
                title: const Text("Jumlah Retur"),
                trailing: Text("${widget.dataRetur.quantity ?? 0} Cup"),
              ),
              ListTile(
                visualDensity: const VisualDensity(vertical: -3),
                title: const Text("Belum diambil"),
                trailing: Text("${widget.dataRetur.notYetTaken ?? 0} Cup"),
              ),
              ListTile(
                visualDensity: const VisualDensity(vertical: -3),
                title: const Text("Sudah diambil"),
                trailing: Text("${widget.dataRetur.alreadyTaken ?? 0} Cup"),
              ),
              ListTile(
                visualDensity: const VisualDensity(vertical: -3),
                title: const Text("Status :"),
                trailing: SizedBox(
                  width: 100,
                  height: 25,
                  child: Label(
                    title: widget.dataRetur.status!.name,
                    status: checkStatusRetur(widget.dataRetur.status!.name!),
                  ),
                ),
              ),
              if (widget.dataRetur.messageRejected != null)
                ExpansionTile(
                  title: const Text("Alasan Penolakan",
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold)),
                  children: [
                    ListTile(
                      visualDensity: const VisualDensity(vertical: -3),
                      title: Text(widget.dataRetur.messageRejected!,
                          style: const TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              const Divider(thickness: 3),
              ListTile(
                visualDensity: const VisualDensity(vertical: -3),
                title: const Text("Detail Retur"),
                subtitle: Text(widget.dataRetur.detail ?? "-"),
              ),
              const Divider(thickness: 3),
              const ListTile(
                visualDensity: VisualDensity(vertical: -3),
                title: Text("Foto Produk yang diretur"),
              ),
              if (widget.dataRetur.image!.isNotEmpty)
                GridView.count(
                  padding: const EdgeInsets.all(15.0),
                  crossAxisSpacing: 10,
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  children: widget.dataRetur.image!
                      .map(
                        (image) => InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                      elevation: 0,
                                      backgroundColor: Colors.transparent,
                                      titleTextStyle:
                                          const TextStyle(color: Colors.white),
                                      insetPadding: EdgeInsets.zero,
                                      content: SizedBox(
                                        width: size.width,
                                        child: PhotoView(
                                          backgroundDecoration:
                                              const BoxDecoration(
                                                  color: Colors.transparent),
                                          imageProvider: NetworkImage(
                                            "$BASE/${image.image}",
                                          ),
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text("kembali",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              )),
                                        ),
                                      ],
                                    ));
                          },
                          child: Card(
                            elevation: 3,
                            child: Image.network(
                              "$BASE/${image.image!}",
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      )
                      .toList(),
                )
              else
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image_not_supported, size: 50),
                        SizedBox(height: 10),
                        Text("Tidak ada Foto"),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 70),
            ]),
            bottomSheet: Builder(builder: (_) {
              if (widget.dataRetur.status!.name! == "Diproses") {
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () {
                              _messageRejectController.clear();
                              _handleRejectRetur(widget.dataRetur);
                            },
                            child: const Text("Tolak")),
                      ),

                      /// TODO Add send notification accept retur
                      const SizedBox(width: 50),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _handleAcceptRetur,
                          child: const Text("Terima"),
                        ),
                      )
                    ],
                  ),
                );
              } else if (widget.dataRetur.status?.name! == "Disetujui") {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(15.0),
                      child: ElevatedButton(
                        onPressed: () => _dialogTakingRetur(),
                        child: const Text("Ambil Produk"),
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox();
            })),
        if (ref.watch(takingReturNotifier).isLoading ||
            ref.watch(rejectReturNotifier).isLoading ||
            ref.watch(createAcceptReturNotifier).isLoading)
          const DialogLoading(),
      ],
    );
  }

  _dialogTakingRetur() {
    showDialog(
        context: context,
        builder: (_) => Form(
              key: _formKeyDialog,
              child: AlertDialog(
                title: const Text("Pengambilan Produk Retur"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FieldInput(
                      suffixText:
                          "Cup / ${widget.dataRetur.notYetTaken ?? 0} Cup",
                      hintText: "0",
                      controller: _quantityCtrl,
                      textValidator: "",
                      keyboardType: TextInputType.number,
                      obsecureText: false,
                      validator: (value) {
                        if (value!.isEmpty || value == "0") {
                          return "Harap di isi";
                        } else if (int.parse(value) >
                            int.parse(widget.dataRetur.notYetTaken!)) {
                          return "Pengambilan tidak boleh lebih dari sisa";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                actions: [
                  FilledButton(
                    onPressed: () {
                      if (_formKeyDialog.currentState!.validate()) {
                        Navigator.of(context).pop();
                        ref
                            .watch(takingReturNotifier.notifier)
                            .takingRetur(
                              widget.dataRetur.id!,
                              quantity: _quantityCtrl.text,
                            )
                            .then((success) {
                          if (success) {
                            Navigator.of(context).pop();
                            showSnackbar(context, "Berhasil ambil produk");
                          } else {
                            showSnackbar(
                              context,
                              ref.watch(takingReturNotifier).error!,
                              isWarning: true,
                            );
                          }
                        });
                      }
                    },
                    child: const Text("Simpan"),
                  )
                ],
              ),
            ));
  }

  _handleRejectRetur(Retur retur) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text("Penolakan Retur"),
              content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FieldInput(
                        hintText: "Masukkan pesan penolakan",
                        controller: _messageRejectController,
                        textValidator: "",
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        obsecureText: false,
                        isRounded: false,
                      ),
                    ],
                  )),
              actions: [
                FilledButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.pop(context);
                        ref
                            .watch(rejectReturNotifier.notifier)
                            .rejectRetur(retur.id!,
                                messageReject: _messageRejectController.text)
                            .then((value) {
                          if (value) {
                            showSnackbar(
                                context, "Berhasil menolak pengajuan retur");
                            Navigator.pop(context);
                          } else {
                            showSnackbar(
                                context, "Gagal Menolak pengajuan retur",
                                isWarning: true);
                          }
                        });
                      }
                    },
                    child: const Text("Kirim")),
              ],
            ));
  }

  _handleAcceptRetur() {
    PanaraConfirmDialog.show(
      context,
      message: "Lanjutkan terima pengajuan retur?",
      confirmButtonText: "Terima",
      cancelButtonText: "Kembali",
      onTapConfirm: () {
        Navigator.of(context).pop();
        ref
            .watch(createAcceptReturNotifier.notifier)
            .createAcceptRetur(widget.dataRetur.id!)
            .then((value) {
          if (value) {
            showSnackbar(context, "Berhasil menerima pengajuan retur");
            Navigator.of(context).pop();
          } else {
            showSnackbar(context, ref.watch(createAcceptReturNotifier).error!,
                isWarning: true);
          }
        });
      },
      onTapCancel: Navigator.of(context).pop,
      panaraDialogType: PanaraDialogType.warning,
    );
  }
}
